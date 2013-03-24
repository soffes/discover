require 'thor'
require 'discover'
require 'set'
require 'ipaddr'

module Discover
  class Cli < Thor
    option :service_type, :type => :string, :desc => 'UPNP service type to filter by'
    option :timeout, :type => :numeric, :desc => 'Timeout in seconds'
    option :first, :type => :boolean, :desc => 'Only return the first result'
    desc 'devices', 'Finds the IP address of all devices on your network'
    def devices
      ssdp = Discover::SSDP.new(options)
      print_devices ssdp.devices
    end

  private

    def print_devices(devices)
      devices = [devices] unless devices.is_a?(Array)
      puts 'No devices found.' and return unless devices and devices.length > 0

      # Sort
      devices = devices.sort do |a, b|
        IPAddr.new(a.ip) <=> IPAddr.new(b.ip)
      end

      # Header
      puts 'IP Address      | Name            | Service Type'
      puts '----------------|-----------------|-------------'

      ips = Set.new
      devices.each do |device|
        next if ips.include?(device.ip)
        ips << device.ip
        puts [
          device.ip.ljust(15),
          sanitize_name(device).ljust(15),
          device.service_type
        ].join(' | ')
      end
    end

    def sanitize_name(device)
      device.name.sub("#{device.ip} - ", '').sub(" (#{device.ip})", '')
    end
  end
end
