module APIClientBase
  module Base
    module ClassMethods

      def new(opts={})
        client_class = self.const_get("Client")
        client_opts = self.configuration.current.merge(opts)
        client_class.new(client_opts)
      end

    end
  end
end
