require 'thor'
require 'discover'
require 'set'

module Discover
  class Cli < Thor
    desc 'devices', 'Finds the IP address of all devices on your network'
    def devices
      ssdp = Discover::SSDP.new
      print_devices ssdp.devices
    end

  private

    def print_devices(devices)
      puts 'No devices found.' and return unless devices and devices.length > 0
      devices = devices.sort do |a, b|
        b.ip <=> a.ip
      end

      ips = Set.new
      devices.each do |device|
        next if ips.include?(device.ip)
        ips << device.ip
        puts "#{device.ip.ljust(9)} #{sanitize_name(device)}"
      end
    end

    def sanitize_name(device)
      device.name.sub("#{device.ip} - ", '').sub(" (#{device.ip})", '')
    end
  end
end
