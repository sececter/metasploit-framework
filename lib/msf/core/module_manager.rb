# -*- coding: binary -*-
#
# Core
#
require 'pathname'

#
# Project
#
require 'msf/core'
require 'msf/core/module_set'

module Msf
  # Upper management decided to throw in some middle management
  # because the modules were getting out of hand.  This bad boy takes
  # care of the work of managing the interaction with modules in terms
  # of loading and instantiation.
  #
  # @todo add unload support
  class ModuleManager
    include Msf::Framework::Offspring

    require 'msf/core/payload_set'

    # require here so that Msf::ModuleManager is already defined
    require 'msf/core/module_manager/cache'
    require 'msf/core/module_manager/loading'
    require 'msf/core/module_manager/module_paths'
    require 'msf/core/module_manager/module_sets'
    require 'msf/core/module_manager/reloading'

    include Msf::ModuleManager::Cache
    include Msf::ModuleManager::Loading
    include Msf::ModuleManager::ModulePaths
    include Msf::ModuleManager::ModuleSets
    include Msf::ModuleManager::Reloading

    include Enumerable

    #
    # CONSTANTS
    #

    # Maps module type directory to its module type.
    TYPE_BY_DIRECTORY = Msf::Modules::Loader::Base::DIRECTORY_BY_TYPE.invert

    def [](key)
      names = key.split("/")
      type = names.shift

      module_set = module_set_by_type[type]

      module_reference_name = names.join("/")
      module_set[module_reference_name]
    end

    # Creates a module instance using the supplied reference name.
    #
    # @param name [String] A module reference name.  It may optionally
    #   be prefixed with a "<type>/", in which case the module will be
    #   created from the {Msf::ModuleSet} for the given <type>.
    #   Otherwise, we step through all sets until we find one that
    #   matches.
    # @return (see Msf::ModuleSet#create)
    def create(name)
      # Check to see if it has a module type prefix.  If it does,
      # try to load it from the specific module set for that type.
      names = name.split("/")
      potential_type_or_directory = names.first

      # if first name is a type
      if Msf::Modules::Loader::Base::DIRECTORY_BY_TYPE.has_key? potential_type_or_directory
        type = potential_type_or_directory
      # if first name is a type directory
      else
        type = TYPE_BY_DIRECTORY[potential_type_or_directory]
      end

      module_instance = nil
      if type
        module_set = module_set_by_type[type]

        # First element in names is the type, so skip it
        module_reference_name = names[1 .. -1].join("/")
        module_instance = module_set.create(module_reference_name)
      else
        # Then we don't have a type, so we have to step through each set
        # to see if we can create this module.
        module_set_by_type.each do |_, set|
          module_reference_name = names.join("/")
          module_instance = set.create(module_reference_name)
          break if module_instance
        end
      end

      module_instance
    end


    # Iterate over all modules in all sets
    #
    # @yieldparam name [String] The module's reference name
    # @yieldparam mod_class [Msf::Module] A module class
    def each
      module_set_by_type.each do |type, set|
        set.each do |name, mod_class|
          yield name, mod_class
        end
      end
    end


    # @param [Msf::Framework] framework The framework for which this instance is managing the modules.
    # @param [Array<String>] types List of module types to load.  Defaults to all module types in {Msf::MODULE_TYPES}.
    def initialize(framework, types=Msf::MODULE_TYPES)
      #
      # defaults
      #

      self.module_info_by_path = {}
      self.enablement_by_type = {}
      self.module_load_error_by_path = {}
      self.module_paths = []
      self.module_set_by_type = {}

      #
      # from arguments
      #

      self.framework = framework

      types.each { |type|
        init_module_set(type)
      }
    end


  ##
  #
  # Translate the provided refname (as used by people insider Metaslpoit), to
  # two arrays for use when loading single modules.
  #
  # Motivation:
  # There are special cases (staged payloads) that require loading multiple
  # files.
  #
  # The first array corresponds to a directory path where the module lives.
  # NOTE: This path is *NOT* a refname, and it is *NOT* a canonical file name.
  # Instead, it is somewhere in the middle =)
  #
  # This is because the loader takes processes things as it walks the directory
  # structure. So, we generate similar intermediate paths for the loader to
  # consume.
  #
  # The first array, "files", includes intermediate filesystem-like paths for
  # the necessary components for this refname.
  # The second array, "paths", includes the paths
  #
  ##
  def fullname_to_paths(type, parts)
    files = []
    paths = []

    # pluralize the path if needed, due to refname and directory structure
    # nomenclature mismatch...
    type_str = type.dup
    type_str << "s" if not [ MODULE_AUX, MODULE_POST ].include? type

    module_paths.each { |path|

      file_base = File.join(path, type_str)

      # Payloads get special treatment
      if type == MODULE_PAYLOAD
        # Try single first
        file = File.join(file_base, "singles", parts)
        file << ".rb"
        if File.exists?(file)
          files << File.join("singles", parts)
          paths << path
          next
        end

        # Is the payload staged?
        stager = parts.last
        # XXX: It would be ideal if this could be resolved without hardcoding it here.
        if stager =~ /^(reverse_|bind_|find_|passivex)/
          os = parts[0,1].first
          # Special case payloads (aliased handlers)
          # XXX: It would be ideal if this could be resolved without hardcoding it here.
          if os == "windows"
            case stager
            when "find_tag"
              stager = "findtag_ord"
            when "reverse_http"
              stager = "passivex"
            end
          end

          stage = parts[-2,1].first
          rest = parts[0, parts.length - 2]
          file1 = File.join(file_base, "stagers", rest, "#{stager}.rb")
          file2 = File.join(file_base, "stages", rest, "#{stage}.rb")
          next if not File.exists?(file1) or not File.exists?(file2)

          # stager, then stage
          files << File.join("stagers", rest, stager)
          paths << path
          files << File.join("stages", rest, stage)
          paths << path
        end

      else
        file = File.join(file_base, parts)
        file << ".rb"
        next if not File.exists?(file)
        files << File.join(parts)
        paths << path

      end
    }

    ret = [ files, paths ]
    ret
  end


    protected

    # This method automatically subscribes a module to whatever event
    # providers it wishes to monitor.  This can be used to allow modules
    # to automatically execute or perform other tasks when certain
    # events occur.  For instance, when a new host is detected, other
    # aux modules may wish to run such that they can collect more
    # information about the host that was detected.
    #
    # @param klass [Class<Msf::Module>] The module class
    # @return [void]
    def auto_subscribe_module(klass)
      # If auto-subscribe has been disabled
      if (framework.datastore['DisableAutoSubscribe'] and
          framework.datastore['DisableAutoSubscribe'] =~ /^(y|1|t)/)
        return
      end

      # If auto-subscription is enabled (which it is by default), figure out
      # if it subscribes to any particular interfaces.
      inst = nil

      #
      # Exploit event subscriber check
      #
      if (klass.include?(Msf::ExploitEvent) == true)
        framework.events.add_exploit_subscriber((inst) ? inst : (inst = klass.new))
      end

      #
      # Session event subscriber check
      #
      if (klass.include?(Msf::SessionEvent) == true)
        framework.events.add_session_subscriber((inst) ? inst : (inst = klass.new))
      end
    end

  end
end

