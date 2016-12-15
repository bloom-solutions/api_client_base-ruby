require 'spec_helper'

RSpec.describe "Code integration", vcr: {record: :once} do

  before(:all) do
    module FakeGem
      class Client
        HOST = "https://jsonplaceholder.typicode.com"
        include APIClientBase::Client.module(default_opts: :default_opts)
        api_action :typicode_user, args: [:user_id]

        private

        def default_opts
          { host: HOST }
        end
      end

      class TypicodeUserRequest
        include APIClientBase::Request.module
        attribute :user_id, Integer

        private

        def path
          "/users/:user_id"
        end
      end

      class TypicodeUserResponse
        include APIClientBase::Response.module

        attribute :body, Object, lazy: true, default: :default_body
        attribute :id, Integer, lazy: true, default: :default_id
        attribute :name, String, lazy: true, default: :default_name

        private

        def default_body
          JSON.parse(raw_response.body)
        end

        def default_id
          body["id"]
        end

        def default_name
          body["name"]
        end
      end
    end
  end

  it "makes it simpler to define client, request, and response objects" do
    client = FakeGem::Client.new
    response = client.typicode_user(1)

    expect(response).to be_success
    expect(response.id).to eq 1
    expect(response.name).to be_a String
  end

end
