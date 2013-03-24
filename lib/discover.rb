require 'discover/version'
require 'discover/ssdp'
require 'discover/Device'

module Discover
  module_function

  def devices(options = {})
    SSDP.new(options).devices
  end

  def first(options = {})
    SSDP.new(options).first
  end
end
