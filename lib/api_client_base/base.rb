module APIClientBase
  module Base

    def self.module(opts={})
      mod = Module.new do
        mattr_accessor :api_client_base_base_options

        def self.included(base)
          base.mattr_accessor :api_client_base_base_options
          base.api_client_base_base_options = self.api_client_base_base_options
          base.send :include, APIClientBase::Base
        end
      end

      mod.api_client_base_base_options = opts

      mod
    end

    extend ActiveSupport::Concern

    included do
      include GemConfig::Base
    end

  end
end
