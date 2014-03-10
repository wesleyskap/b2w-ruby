require 'rubygems'
require 'bundler/setup'
require 'b2w'

RSpec.configure do |config|

end

B2W.config! token: File.read('spec/token').strip, sandbox: true
