require 'spec_helper'

module APIClientBase
  RSpec.describe Request do

    describe "#action" do
      it "defaults to :get" do
        request_class = Class.new do
          include APIClientBase::Request.module
        end
        request = request_class.new
        expect(request.action).to eq :get
      end

      it "can be set directly from Request import" do
        request_class = Class.new do
          include APIClientBase::Request.module(action: :post)
        end
        request = request_class.new
        expect(request.action).to eq :post
      end
    end

    describe "#uri" do
      context "path is not defined" do
        it "does not apply the path to `host`" do
          request_class = Class.new do
            include APIClientBase::Request.module
          end

          request = request_class.new(host: "http://d.c/hi/there")
          expect(request.uri).to eq "http://d.c/hi/there"
        end
      end

      context "path is defined and host has a path" do
        it "joins the path" do
          request_class = Class.new do
            include APIClientBase::Request.module

            def path
              "/moar"
            end
          end

          request = request_class.new(host: "http://d.c/hi/there")
          expect(request.uri).to eq "http://d.c/hi/there/moar"
        end
      end
    end

    describe "#api_client_base_path" do
      it "is built from the request's attributes" do
        request_class = Class.new do
          include APIClientBase::Request.module
          attribute :here, Integer
          attribute :there, Integer

          private

          def path
            "/go/:here/and/:there"
          end
        end
        request = request_class.new(here: 2, there: "needs escaping")
        expect(request.api_client_base_path).to eq "/go/2/and/needs+escaping"
      end
    end

    describe "#before_call" do
      it "first thing called in `#call`", vcr: {record: :once} do
        request_class = Class.new do
          include APIClientBase::Request.module
          attribute :before_call_test, String
          attribute :user_id, Integer

          private

          def path
            "/users/:user_id"
          end

          def before_call
            self.before_call_test = "called"
          end
        end

        request = request_class.new({
          host: "https://jsonplaceholder.typicode.com",
          user_id: 1,
        })
        expect(request.before_call_test).to be_nil

        request.()

        expect(request.before_call_test).to eq "called"
      end
    end

    describe "#run" do
      let(:request_class) do
        Class.new do
          include APIClientBase::Request.module

          private

          def action
            "post"
          end

          def headers
            {"Content-Type" => "application/json"}
          end

          def body
            {"bo" => "deh"}.to_json
          end

          def params
            {hi: "there"}
          end

        end
      end
      let(:request) do
        request_class.new(
          host: "https://jsonplaceholder.typicode.com",
        )
      end
      let(:typhoeus_request) { instance_double(Typhoeus::Request) }

      it "makes the typhoeus call" do
        expect(request).to receive(:run).and_call_original

        expect(Typhoeus::Request).to receive(:new).with(
          "https://jsonplaceholder.typicode.com",
          method: "post",
          headers: {"Content-Type" => "application/json"},
          body: {"bo" => "deh"}.to_json,
          params: {hi: "there"},
        ).and_return(typhoeus_request)

        expect(typhoeus_request).to receive(:run)

        request.()
      end
    end

    describe "typhoeus options" do
      let(:request_class) do
        Class.new do
          include APIClientBase::Request.module

          def params
            {my: "params"}
          end

          def body
            {my: "body"}.to_json
          end

          def headers
            {headers: "ok"}
          end

          def typhoeus_options
            { userpwd: "hi:there" }
          end
        end
      end
      let(:request) do
        request_class.new(
          host: "https://jsonplaceholder.typicode.com",
          proxy: "proxy.com",
        )
      end
      let(:typhoeus_request) { instance_double(Typhoeus::Request) }

      it "uses #{BuildTyphoeusOptions}" do
        expect(BuildTyphoeusOptions).to receive(:call).with(
          method: :get,
          headers: {headers: "ok"},
          body: {my: "body"}.to_json,
          params: {my: "params"},
          proxy: "proxy.com",
          userpwd: "hi:there",
        ).and_return({some: "options"})

        expect(Typhoeus::Request).to receive(:new).with(
          "https://jsonplaceholder.typicode.com",
          {some: "options"},
        ).and_return(typhoeus_request)

        expect(typhoeus_request).to receive(:run)

        request.()
      end
    end

  end
end
