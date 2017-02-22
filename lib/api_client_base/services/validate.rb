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
      schema.(attrs).errors
    end

    def self.schema_of(klass)
      "#{klass.name}Schema".constantize
    rescue NameError
    end

  end
end
