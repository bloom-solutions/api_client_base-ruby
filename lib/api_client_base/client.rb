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
      include APIClientBase::Client::Attributes
      extend APIClientBase::Client::ClassMethods

      private

      def _api_client_call_hook_with(request, response)
        hook = _api_client_after_response
        return if hook.nil?

        hook.(request, response)
      end

      def _api_client_gem_module
        @_api_client_gem_module ||= self.class.name.deconstantize.constantize
      end

      def _api_client_after_response
        return nil if not _api_client_gem_module.respond_to?(:configuration)
        _api_client_gem_module.configuration.after_response
      end
    end

  end
end
