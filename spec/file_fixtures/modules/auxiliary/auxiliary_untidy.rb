##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

# XXX: invalid super class for an auxiliary module
class Metasploit4 < Msf::Exploit
  def initialize(info = {})
    super(
      update_info(
        info,
        'Name'            => 'Untidy Auxiliary Module for RSpec'
        'Description'     => 'Test!'
        },
        'Author'         => %w(Unknown),
        'License'        => MSF_LICENSE,
      )
    )
  end
end

