require 'spec_helper'

module APIClientBase
  RSpec.describe self::Base do

    before do
      module GemTestBase
        include APIClientBase::Base.module

        with_configuration do
          has :host, classes: String
          has :username, classes: String
          has :password, classes: String
        end

        class Client
          include APIClientBase::Client.module
        end
      end
    end

    it "instantiation of ::Client passing options (priority of given over default)" do
      GemTestBase.configure do |c|
        c.host = "https://prod.com"
        c.username = "uname"
      end

      client = GemTestBase.new(host: "https://test.com", password: "pazz")
      expect(client.host).to eq "https://test.com"
      expect(client.username).to eq "uname"
      expect(client.password).to eq "pazz"
    end

    it "allows passing of nothing" do
      GemTestBase.configure do |c|
        c.host = "https://prod.com"
        c.username = "uname"
      end

      client = GemTestBase.new
      expect(client.host).to eq "https://prod.com"
      expect(client.username).to eq "uname"
      expect(client.password).to be_nil
    end

  end
end
