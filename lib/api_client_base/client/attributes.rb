module APIClientBase
  module Client
    module Attributes

      def self.included(base)
        base.include Virtus.model
        inherit_attributes!(base)
      end

      private

      def self.inherit_attributes!(klass)
        parent_module = _api_client_parent_module(klass)
        return unless parent_module.respond_to?(:configuration)
        parent_module.configuration.rules.each do |rule|
          self.inherit_attribute!(klass, rule)
        end
      end

      def self.inherit_attribute!(klass, rule)
        klass.attribute rule[0]
      end

      def self._api_client_parent_module(klass)
        klass.name.deconstantize.constantize
      end

    end
  end
end
