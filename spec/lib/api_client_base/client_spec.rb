require 'spec_helper'

module APIClientBase
  RSpec.describe Client, type: %i[virtus] do

    describe ".api_action", vcr: {record: :once} do
      before do
        module APIActionTestGemClient
          class Client
            include APIClientBase::Client.module(default_opts: :default_opts)
            include Virtus.model
            attribute :host, String
            api_action :argless_call
            api_action :get_post
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

          class GetPostRequest
            include APIClientBase::Request.module
            attribute :id

            def path
              "/posts/:id"
            end
          end

          class GetPostResponse
            include APIClientBase::Response.module
            attribute :id, String, default: :default_id
            attribute :title, String, default: :default_title

            def default_id
              data["id"]
            end

            def default_title
              data["title"]
            end

            def data
              JSON.parse(raw_response.body)
            end
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

      it "allows calls with implicit args", vcr: {record: :once} do
        client = APIActionTestGemClient::Client.new(
          host: "http://jsonplaceholder.typicode.com/",
        )
        response = client.get_post(id: 2)
        expect(response.id).to eq "2"
        expect(response.title).to eq "qui est esse"
      end

      it "allows customization of arity/args", vcr: {record: :once} do
        client = APIActionTestGemClient::Client.new(
          host: "http://jsonplaceholder.typicode.com/",
        )
        response = client.get_comment("1", "id labore ex et quam laborum")
        expect(response.id).to eq "1"
        expect(response.name).to eq "id labore ex et quam laborum"
      end

      it "does not singularize the actions" do
        client = APIActionTestGemClient::Client.new(host: "http://google.com")
        expect { client.get_balls }.to_not raise_error
      end
    end

    describe "inherited attributes" do
      before do
        module InheritedAttrsTestGem
          include APIClientBase::Base.module

          with_configuration do
            has :host, classes: String, default: "https://host.com"
            has :log, values: [true, false], default: false
            has :logger
          end

          class Client
            include APIClientBase::Client.module
          end
        end
      end
      subject(:client_class) { InheritedAttrsTestGem::Client }

      it "inherits attributes based on the configuration" do
        expect(client_class).to have_attribute(:host)
        expect(client_class).to have_attribute(:log)
        expect(client_class).to have_attribute(:logger)
      end

      it "receives values from the parent module config" do
        client = InheritedAttrsTestGem.new(log: false)
        expect(client.host).to eq "https://host.com"
        expect(client.log).to eq false
        expect(client.logger).to be_nil
      end
    end

  end
end
