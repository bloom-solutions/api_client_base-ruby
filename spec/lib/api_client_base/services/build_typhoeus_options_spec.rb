require 'spec_helper'

module APIClientBase
  RSpec.describe BuildTyphoeusOptions do

    %i[
      method
      headers
      body
      params
    ].each do |attr|
      it "includes `#{attr}`" do
        result = described_class.(attr => "val")
        expect(result[attr]).to eq "val"
      end
    end

    context "proxy is present" do
      it "includes proxy" do
        result = described_class.(proxy: "hi.com")

        expect(result[:proxy]).to eq "hi.com"
      end
    end

    context "proxy is blank" do
      it "does not include proxy" do
        result = described_class.(proxy: "")

        expect(result).to_not have_key(:proxy)
      end
    end

  end
end
