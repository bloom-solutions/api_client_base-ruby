require 'spec_helper'

module APIClientBase
  RSpec.describe Response, type: %i[virtus] do

    describe "attributes" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end
      subject { response_class }
      it { is_expected.to have_attribute(:raw_response) }
      it { is_expected.to have_attribute(:success) }
      it { is_expected.to have_attribute(:code, Integer) }
    end

    describe "#headers" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end
      let(:headers) do
        { "CONTENT-TYPE" => "application/json" }
      end
      let(:raw_response) do
        instance_double(Typhoeus::Response, headers: headers)
      end
      let(:response) { response_class.new(raw_response: raw_response) }

      it "gives access to the headers hash" do
        expect(response.headers).to eq headers
      end
    end

    describe "#header" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end
      let(:raw_response) do
        instance_double(Typhoeus::Response, headers: headers)
      end
      let(:response) { response_class.new(raw_response: raw_response) }

      context "headers is nil" do
        let(:headers) { nil }
        subject { response.header("Content-Type") }
        it { is_expected.to be_nil }
      end

      context "headers exist but no key" do
        let(:headers) { {} }
        subject { response.header("Content-Type") }
        it { is_expected.to be_nil }
      end

      context "header exists" do
        let(:headers) { {"Content-Type" => "application/json"} }

        context "exact match" do
          subject { response.header("Content-Type") }
          it { is_expected.to eq "application/json" }
        end

        context "different case" do
          subject { response.header("content-type") }
          it { is_expected.to eq "application/json" }
        end
      end
    end

    describe "#success?" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end

      it "defaults to the raw_response.success" do
        raw_response = instance_double(Typhoeus::Response, success?: true)
        response = response_class.new(raw_response: raw_response)
        expect(response).to be_success

        raw_response = instance_double(Typhoeus::Response, success?: false)
        response = response_class.new(raw_response: raw_response)
        expect(response).to_not be_success
      end
    end

    describe "#code" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end

      it "defaults to the raw_response.success" do
        raw_response = instance_double(Typhoeus::Response, code: 204)
        response = response_class.new(raw_response: raw_response)
        expect(response.code).to eq 204
      end
    end

    describe "#body" do
      let(:response_class) do
        Class.new do
          include APIClientBase::Response.module
        end
      end

      it "is the body of the raw_response" do
        raw_response = instance_double(Typhoeus::Response, body: "hi")
        response = response_class.new(raw_response: raw_response)
        expect(response.body).to eq "hi"
      end
    end

  end
end
