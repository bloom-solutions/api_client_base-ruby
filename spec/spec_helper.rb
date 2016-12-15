$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pry-byebug"
require "api_client_base"
require "virtus-matchers"
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
