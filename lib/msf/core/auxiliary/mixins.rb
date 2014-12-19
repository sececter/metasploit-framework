# -*- coding: binary -*-

#
# Auxiliary mixins
#
module Msf
class Auxiliary
  # Main types of auxiliary modules
  autoload :AuthBrute,  'msf/core/auxiliary/auth_brute'
  autoload :Dos,        'msf/core/auxiliary/dos'
  autoload :DRDoS,      'msf/core/auxiliary/drdos'
  autoload :Fuzzer,     'msf/core/auxiliary/fuzzer'
  autoload :Scanner,    'msf/core/auxiliary/scanner'
  autoload :UDPScanner, 'msf/core/auxiliary/udp_scanner'
  autoload :Timed,      'msf/core/auxiliary/timed'
  autoload :Web,        'msf/core/auxiliary/web'

  # Wmap
  autoload :WmapModule,          'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanSSL,         'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanFile,        'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanDir,         'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanServer,      'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanQuery,       'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanUniqueQuery, 'msf/core/auxiliary/wmapmodule'
  autoload :WmapScanGeneric,     'msf/core/auxiliary/wmapmodule'
  autoload :WmapCrawler,         'msf/core/auxiliary/wmapmodule'
  autoload :HttpCrawler,         'msf/core/auxiliary/crawler'

  # Miscallaneous
  autoload :Report,        'msf/core/auxiliary/report'
  autoload :CommandShell,  'msf/core/auxiliary/commandshell'
  autoload :Nmap,          'msf/core/auxiliary/nmap'
  autoload :PII,           'msf/core/auxiliary/pii'

  # Protocol augmenters for Aux modules
  autoload :Login,     'msf/core/auxiliary/login'
  autoload :RServices, 'msf/core/auxiliary/rservices'
  autoload :Cisco,     'msf/core/auxiliary/cisco'
  autoload :IAX2,      'msf/core/auxiliary/iax2'
  autoload :NTP,       'msf/core/auxiliary/ntp'
  autoload :NATPMP,    'msf/core/auxiliary/natpmp'
  autoload :Kademlia,  'msf/core/auxiliary/kademlia'

end
end
