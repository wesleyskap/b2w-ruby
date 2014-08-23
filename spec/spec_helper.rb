require 'rubygems'
require 'bundler/setup'
require 'webmock'
require 'vcr'
require 'b2w'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
end

B2W.config! token: File.read('spec/token').strip
