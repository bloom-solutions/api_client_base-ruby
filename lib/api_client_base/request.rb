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
      require "typhoeus"
      if defined?(Typhoeus)
        request = Typhoeus::Request.new(
          uri,
          method: action,
          headers: headers,
          body: body,
          params: params,
        )

        request.run
      else
        fail "Either override #call or make sure Typhoeus is available for use."
      end
    end

    private

    def headers ; {}  ; end
    def body    ; nil ; end
    def params  ; {}  ; end

    def default_action
      self.class.api_client_base_request_options[:action] || :get
    end

    def default_uri
      uri = if !api_client_base_path.nil?
              path = URI.parse(host).path
              if !path.empty?
                URI.join(
                  host, 
                  [path, "/"].join, 
                  api_client_base_path[1..-1]
                )
              else
                URI.join(host, api_client_base_path)
              end
            else
              URI(host)
            end

      uri.to_s
    end

    def default_api_client_base_path
      return if !respond_to?(:path, true)
      path.scan(/:\w+/).reduce(path) do |new_path, var|
        attribute_name = var.gsub(":", "")
        value = CGI::escape(self.send(attribute_name).to_s)
        new_path.gsub(var, value.to_s)
      end
    end

  end
end
