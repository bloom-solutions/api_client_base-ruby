require "spec_helper"

describe APIClientBase do
  it "has a version number" do
    expect(APIClientBase::VERSION).not_to be nil
  end
end
