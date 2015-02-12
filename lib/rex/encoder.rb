##
# $Id: encoder.rb 12554 2011-05-06 18:47:10Z jduck $
#
# This file maps encoders for autoload
##

module Rex::Encoder
  # Encoder support code
  autoload :Xor,      'rex/encoder/xor'
  autoload :Alpha2,   'rex/encoder/alpha2'
  autoload :NonAlpha, 'rex/encoder/nonalpha'
  autoload :NonUpper, 'rex/encoder/nonupper'

  # Hrm? Is these in the wrong module?
  autoload :XDR, 'rex/encoder/xdr'
  autoload :NDR, 'rex/encoder/ndr'
end
