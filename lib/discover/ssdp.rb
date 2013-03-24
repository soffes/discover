require 'socket'
require 'ipaddr'
require 'timeout'

module Discover
  class SSDP
    # Listen for all devices
    ALL_SERVICE_TYPE = 'ssdp:all'.freeze
    # SSDP multicast IPv4 address
    MULTICAST_ADDR = '239.255.255.250'.freeze

    # SSDP UDP port
    MULTICAST_PORT = 1900.freeze

    # Timeout in 5 second
    DEFAULT_TIMEOUT = 1.freeze

    attr_reader :service_type
    attr_reader :timeout

    # @param service_type [String] the identifier of the device you're trying to find
    # @param timeout [Fixnum] timeout in seconds
    def initialize(options = {})
      @service_type = (options[:service_type] || ALL_SERVICE_TYPE)
      @timeout = (options[:timeout] || DEFAULT_TIMEOUT)
      initialize_socket
    end

    # Look for devices on the network
    def devices
      @socket.send(search_message, 0, MULTICAST_ADDR, MULTICAST_PORT)
      listen_for_responses()
    end

    # Look for the first devices on the network
    def first
      @socket.send(search_message, 0, MULTICAST_ADDR, MULTICAST_PORT)
      listen_for_responses(true)
    end

  private

    def listen_for_responses(first = false)
      @socket.send(search_message, 0, MULTICAST_ADDR, MULTICAST_PORT)

      devices = []
      Timeout::timeout(timeout) do
        loop do
          device = Device.new(@socket.recvfrom(2048))
          device = nil unless !service_type || service_type == device.service_type

          if first
            return device
          else
            devices << device
          end
        end
      end
      devices

    rescue Timeout::Error => ex
      devices
    end

    def initialize_socket
      # Create a socket
      @socket = UDPSocket.open

      # We're going to use IP with the multicast TTL. Mystery third parameter is a mystery.
      @socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_MULTICAST_TTL, 2)
    end

    def search_message
     [
        'M-SEARCH * HTTP/1.1',
        "HOST: #{MULTICAST_ADDR}:reservedSSDPport",
        'MAN: ssdp:discover',
        "MX: #{timeout}",
        "ST: #{service_type || ALL_SERVICE_TYPE}"
      ].join("\n")
    end
  end
end
