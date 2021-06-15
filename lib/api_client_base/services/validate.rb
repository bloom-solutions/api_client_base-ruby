module APIClientBase
  class Validate

    def self.call(klass, attrs)
      errors = errors_of(klass, attrs)
      fail(ArgumentError, errors.to_json) if errors.any?
    end

    private

    def self.errors_of(klass, attrs)
      schema = schema_of(klass)
      return [] if schema.nil?

      schema.(attrs).errors.to_h
    end

    def self.schema_of(klass)
      contract_class = "#{klass.name}Schema".constantize

      return contract_class if Dry::Validation.const_defined?("Schema")

      contract_class.new
    rescue NameError
    end

  end
end
