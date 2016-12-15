module APIClientBase
  module Request

    def self.module(opts={})
      mod = Module.new do
        mattr_accessor :api_client_base_request_options

        def self.included(base)
          base.class_attribute :api_client_base_request_options
          base.api_client_base_request_options =
            self.api_client_base_request_options
          base.send :include, APIClientBase::Request
        end
      end

      mod.api_client_base_request_options = opts

      mod
    end

    extend ActiveSupport::Concern

    included do
      include Virtus.model
      attribute :host, String
      attribute :uri, String, lazy: true, default: :default_uri
      attribute :action, Symbol, default: :default_action
      attribute(:api_client_base_path, String, {
        lazy: true,
        default: :default_api_client_base_path,
      })
    end

    def call
      request = Typhoeus::Request.new(
        uri,
        method: action,
        headers: headers,
        body: body,
        params: params,
      )

      request.run
    end

    private

    def headers ; {}  ; end
    def body    ; nil ; end
    def params  ; {}  ; end

    def default_action
      self.class.api_client_base_request_options[:action] || :get
    end

    def default_uri
      uri = URI(host)
      uri.path = api_client_base_path
      uri.to_s
    end

    def default_api_client_base_path
      path.scan(/:\w+/).reduce(path) do |new_path, var|
        attribute_name = var.gsub(":", "")
        value = self.send(attribute_name)
        new_path.gsub(var, value.to_s)
      end
    end

  end
end
