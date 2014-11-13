# -*- coding: binary -*-

# This module provides a way of interacting with certain web applications
module Msf
  module HTTP
    autoload :Wordpress,  'msf/http/wordpress'
    autoload :Typo3,      'msf/http/typo3'
    autoload :JBoss,      'msf/http/jboss'
  end
end

