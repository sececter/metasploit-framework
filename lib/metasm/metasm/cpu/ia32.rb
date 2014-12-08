#    This file is part of Metasm, the Ruby assembly manipulation suite
#    Copyright (C) 2006-2009 Yoann GUILLOT
#
#    Licence is LGPL, see LICENCE in the top-level directory

# fix autorequire warning
class Metasm::Ia32 < Metasm::CPU
end

require 'metasm/metasm/main'
require 'metasm/metasm/cpu/ia32/parse'
require 'metasm/metasm/cpu/ia32/encode'
require 'metasm/metasm/cpu/ia32/decode'
require 'metasm/metasm/cpu/ia32/render'
require 'metasm/metasm/cpu/ia32/compile_c'
require 'metasm/metasm/cpu/ia32/decompile'
require 'metasm/metasm/cpu/ia32/debug'
