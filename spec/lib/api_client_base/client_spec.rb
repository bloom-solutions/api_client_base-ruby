require 'spec_helper'

module APIClientBase
  RSpec.describe Client do

    describe ".api_action", vcr: {record: :once} do
      it "allows calls without args" do
        module TestGemClient
          class Client
            include APIClientBase::Client.module(default_opts: :default_opts)
            include Virtus.model
            attribute :host, String
            api_action :argless_call

            def default_opts
              { host: host }
            end
          end

          class ArglessCallRequest
            include APIClientBase::Request.module

            def path
              "/"
            end
          end

          class ArglessCallResponse
            include APIClientBase::Response.module
          end
        end

        client = TestGemClient::Client.new(host: "http://google.com")
        expect { client.argless_call }.to_not raise_error
      end
    end

  end
end
