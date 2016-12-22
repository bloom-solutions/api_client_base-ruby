require 'spec_helper'

module APIClientBase
  RSpec.describe Client do

    describe ".api_action", vcr: {record: :once} do
      before do
        module TestGemClient
          class Client
            include APIClientBase::Client.module(default_opts: :default_opts)
            include Virtus.model
            attribute :host, String
            api_action :argless_call
            api_action :get_balls

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

          class GetBallsRequest
            include APIClientBase::Request.module

            def path
              "/"
            end
          end

          class GetBallsResponse
            include APIClientBase::Response.module
          end
        end
      end

      it "allows calls without args" do
        client = TestGemClient::Client.new(host: "http://google.com")
        expect { client.argless_call }.to_not raise_error
      end

      it "does not singularize the actions" do
        client = TestGemClient::Client.new(host: "http://google.com")
        expect { client.get_balls }.to_not raise_error
      end
    end

  end
end
