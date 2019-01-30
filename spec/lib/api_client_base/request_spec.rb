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

  end
end
