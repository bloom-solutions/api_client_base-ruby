module APIClientBase
  module Client

    def self.module(opts={})
      mod = Module.new do
        mattr_accessor :api_client_base_client_options

        def self.included(base)
          base.class_attribute :api_client_base_client_options
          base.api_client_base_client_options = self.api_client_base_client_options
          base.send :include, APIClientBase::Client
        end
      end

      mod.api_client_base_client_options = opts

      mod
    end

    extend ActiveSupport::Concern

    included do
      extend APIClientBase::Client::ClassMethods
    end

  end
end
