module APIClientBase
  module Client
    module ClassMethods

      def api_action(action_name, opts={})
        define_method action_name do |args={}|
          namespace = self.class.name.deconstantize.constantize

          request_class_name = [action_name.to_s.classify, "Request"].join
          request_class = namespace.const_get(request_class_name)

          response_class_name = [action_name.to_s.classify, "Response"].join
          response_class = namespace.const_get(response_class_name)

          if opts[:args].is_a?(Array)
            request_args = opts[:args].each_with_object({}).
              with_index { |(arg, hash), i| hash[arg] = args[i] }
          else
            request_args = args
          end

          default_request_opts_method =
            self.class.api_client_base_client_options[:default_opts]
          default_request_opts = send(default_request_opts_method)

          request = request_class.new(default_request_opts.merge(request_args))
          raw_response = request.()
          response_class.new(raw_response: raw_response)
        end
      end

    end
  end
end
