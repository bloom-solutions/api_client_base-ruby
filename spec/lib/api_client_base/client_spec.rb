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
            api_action :get_comment, args: [:post_id, :name]

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

          class GetCommentRequest
            include APIClientBase::Request.module
            attribute :post_id
            attribute :name

            def path
              "/comments"
            end

            def params
              {postId: post_id, name: name}
            end
          end

          class GetCommentResponse
            include APIClientBase::Response.module
            attribute :id, String, default: :default_id
            attribute :name, String, default: :default_name

            def matching_post
              JSON.parse(raw_response.body).first
            end

            def default_id
              matching_post["id"]
            end

            def default_name
              matching_post["name"]
            end
          end
        end
      end

      it "allows calls without args" do
        client = TestGemClient::Client.new(host: "http://google.com")
        expect { client.argless_call }.to_not raise_error
      end

      it "allows customization of arity/args", vcr: {record: :once} do
        client = TestGemClient::Client.new(
          host: "http://jsonplaceholder.typicode.com/",
        )
        response = client.get_comment("1", "id labore ex et quam laborum")
        expect(response.id).to eq "1"
        expect(response.name).to eq "id labore ex et quam laborum"
      end

      it "does not singularize the actions" do
        client = TestGemClient::Client.new(host: "http://google.com")
        expect { client.get_balls }.to_not raise_error
      end
    end

  end
end
