# -*- coding: binary -*-
###
#
# framework-core
# --------------
#
# The core library provides all of the means by which to interact
# with the framework insofar as manipulating encoders, nops,
# payloads, exploits, auxiliary, and sessions.
#
###

# Sanity check this version of ruby
require 'msf/sanity'

# The framework-core depends on Rex
require 'rex'

# Set the log source, and initialize demand-loaded requires
module Msf
  autoload :Author, 'msf/core/author'
  autoload :Platform, 'msf/core/platform'
  autoload :Reference, 'msf/core/reference'
  autoload :SiteReference, 'msf/core/site_reference'
  autoload :Target, 'msf/core/target'

  #
  # Constants
  #

  LogSource = "core"

  # Event subscriber interfaces
  autoload :UiEventSubscriber, 'msf/events'

  # Wrappers
  autoload :EncodedPayload, 'msf/core/encoded_payload'

  # Pseudo-modules
  autoload :Handler, 'msf/core/handler'

  # Mixins
  autoload :Encoder,       'msf/core/encoder'
  autoload :EncoderState,  'msf/core/encoder'
  autoload :Auxiliary,     'msf/core/auxiliary'
  autoload :Nop,           'msf/core/nop'
  autoload :Payload,       'msf/core/payload'
  autoload :ExploitEvent,  'msf/core/exploit'
  autoload :Exploit,       'msf/core/exploit'
  autoload :Post,          'msf/core/post'

  # Custom HTTP Modules
  autoload :HTTP,          'msf/http'

  # Drivers
  autoload :ExploitDriver, 'msf/core/exploit_driver'

  # Framework context and core classes
  autoload :Framework, 'msf/core/framework'

  # Session stuff
  autoload :Session,      'msf/core/session'
  autoload :SessionEvent, 'msf/core/session'

  autoload :Util, 'msf/util'
end

# General
require 'msf/core/constants'
require 'msf/core/exceptions'
require 'msf/core/data_store'
require 'msf/core/option_container'

# Event subscriber interfaces
require 'msf/events'

# Framework context and core classes
require 'msf/core/db_manager'
require 'msf/core/event_dispatcher'
require 'msf/core/module_manager'
require 'msf/core/module_set'
require 'msf/core/plugin_manager'
require 'msf/core/session_manager'

# Modules
require 'msf/core/module'

