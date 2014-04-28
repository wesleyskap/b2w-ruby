require 'rest-client'
require "b2w/base"
require "b2w/order"
require "b2w/version"
require "json"

module B2W
  def self.config!(config)
    @config = config
  end

  def self.config
    @config
  end
end
