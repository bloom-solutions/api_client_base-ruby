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
