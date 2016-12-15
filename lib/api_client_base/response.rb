module APIClientBase
  module Response

    def self.module(opts={})
      mod = Module.new do
        mattr_accessor :api_client_base_response_options

        def self.included(base)
          base.class_attribute :api_client_base_response_options
          base.api_client_base_response_options =
            self.api_client_base_response_options
          base.send :include, APIClientBase::Response
        end
      end

      mod.api_client_base_response_options = opts

      mod
    end

    extend ActiveSupport::Concern

    included do
      include Virtus.model
      attribute :raw_response, Object
      attribute :success, self::Boolean, lazy: true, default: :default_success
      attribute :code, Integer, lazy: true, default: :default_code
    end

    def default_success
      raw_response.success?
    end

    def default_code
      raw_response.code
    end

  end
end
