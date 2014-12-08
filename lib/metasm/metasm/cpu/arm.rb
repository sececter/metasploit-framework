#    This file is part of Metasm, the Ruby assembly manipulation suite
#    Copyright (C) 2006-2009 Yoann GUILLOT
#
#    Licence is LGPL, see LICENCE in the top-level directory

class Metasm::ARM < Metasm::CPU
end

require 'metasm/metasm/main'
require 'metasm/metasm/cpu/arm/parse'
require 'metasm/metasm/cpu/arm/encode'
require 'metasm/metasm/cpu/arm/decode'
require 'metasm/metasm/cpu/arm/render'
require 'metasm/metasm/cpu/arm/debug'
