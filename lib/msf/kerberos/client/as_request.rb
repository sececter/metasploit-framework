# -*- coding: binary -*-
require 'rex/proto/kerberos'

module Msf
  module Kerberos
    module Client
      module AsRequest

        # Builds a kerberos AS request
        #
        # @param opts [Hash{Symbol => <Array<Rex::Proto::Kerberos::Model::PreAuthData>, Rex::Proto::Kerberos::Model::KdcRequestBody>}]
        # @option opts [Array<Rex::Proto::Kerberos::Model::PreAuthData>] :pa_data
        # @option opts [Rex::Proto::Kerberos::Model::KdcRequestBody] :body
        # @return [Rex::Proto::Kerberos::Model::KdcRequest]
        # @see [Rex::Proto::Kerberos::Model::KdcRequest]
        # @see #build_as_pa_time_stamp
        # @see #build_as_request_body
        def build_as_request(opts = {})
          pa_data = opts[:pa_data] || build_as_pa_time_stamp(opts)
          body = opts[:body] || build_as_request_body(opts)

          request = Rex::Proto::Kerberos::Model::KdcRequest.new(
            pvno: 5,
            msg_type: Rex::Proto::Kerberos::Model::AS_REQ,
            pa_data: pa_data,
            req_body: body
          )

          request
        end

        # Builds a kerberos PA-ENC-TIMESTAMP pre authenticated structure
        #
        # @param opts [Hash{Symbol => <Time, Fixnum, String>}]
        # @option opts [Time] :time_stamp
        # @option opts [Fixnum] :pausec
        # @option opts [Fixnum] :etype
        # @option opts [String] :key
        # @return [Rex::Proto::Kerberos::Model::PreAuthData]
        # @see Rex::Proto::Kerberos::Model::PreAuthEncTimeStamp
        # @see Rex::Proto::Kerberos::Model::EncryptedData
        # @see Rex::Proto::Kerberos::Model::PreAuthData
        def build_as_pa_time_stamp(opts = {})
          time_stamp = opts[:time_stamp] || Time.now
          pausec = opts[:pausec] || 0
          etype = opts[:etype] || Rex::Proto::Kerberos::Crypto::RC4_HMAC
          key = opts[:key] || ''

          pa_time_stamp = Rex::Proto::Kerberos::Model::PreAuthEncTimeStamp.new(
              pa_time_stamp: time_stamp,
              pausec: pausec
          )

          enc_time_stamp = Rex::Proto::Kerberos::Model::EncryptedData.new(
              etype: etype,
              cipher: pa_time_stamp.encrypt(etype, key)
          )

          pa_enc_time_stamp = Rex::Proto::Kerberos::Model::PreAuthData.new(
              type: Rex::Proto::Kerberos::Model::PA_ENC_TIMESTAMP,
              value: enc_time_stamp.encode
          )

          pa_enc_time_stamp
        end

        # Builds a kerberos AS request body
        #
        # @param opts [Hash{Symbol => <Fixnum, Time, String, Rex::Proto::Kerberos::Model::PrincipalName>}]
        # @option opts [Fixnum] :options
        # @option opts [Time] :from
        # @option opts [Time] :till
        # @option opts [Time] :rtime
        # @option opts [Fixnum] :nonce
        # @option opts [Fixnum] :etype
        # @option opts [Rex::Proto::Kerberos::Model::PrincipalName] :cname
        # @option opts [String] :realm
        # @option opts [Rex::Proto::Kerberos::Model::PrincipalName] :sname
        # @return [Rex::Proto::Kerberos::Model::KdcRequestBody]
        # @see #build_client_name
        # @see #build_server_name
        # @see Rex::Proto::Kerberos::Model::KdcRequestBody
        def build_as_request_body(opts = {})
          options = opts[:options] || 0x50800000 # Forwardable, Proxiable, Renewable
          from = opts[:from] || Time.utc('1970-01-01-01 00:00:00')
          till = opts[:till] || Time.utc('1970-01-01-01 00:00:00')
          rtime = opts[:rtime] || Time.utc('1970-01-01-01 00:00:00')
          nonce = opts[:nonce] || Rex::Text.rand_text_numeric(6).to_i
          etype = opts[:etype] || [Rex::Proto::Kerberos::Crypto::RC4_HMAC]
          cname = opts[:cname] || build_client_name(opts)
          realm = opts[:realm] || ''
          sname = opts[:sname] || build_server_name(opts)

          body = Rex::Proto::Kerberos::Model::KdcRequestBody.new(
            options: options,
            cname: cname,
            realm: realm,
            sname: sname,
            from: from,
            till: till,
            rtime: rtime,
            nonce: nonce,
            etype: etype
          )

          body
        end
      end
    end
  end
end
