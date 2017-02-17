module APIClientBase
  module Client
    module Attributes

      def self.included(base)
        base.include Virtus.model
        inherit_attributes!(base)
      end

      private

      def self.inherit_attributes!(klass)
        parent_module = klass.name.deconstantize.constantize
        return unless parent_module.respond_to?(:configuration)
        parent_module.configuration.rules.each do |rule|
          self.inherit_attribute!(klass, rule)
        end
      end

      def self.inherit_attribute!(klass, rule)
        klass.attribute rule[0]
      end

    end
  end
end
