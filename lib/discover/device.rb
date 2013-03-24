require 'net/http'
require 'uri'
require 'nokogiri'

module Discover
  class Device
    attr_reader :ip
    attr_reader :port
    attr_reader :description_url
    attr_reader :server
    attr_reader :service_type
    attr_reader :usn
    attr_reader :url_base
    attr_reader :name
    attr_reader :manufacturer
    attr_reader :manufacturer_url
    attr_reader :model_name
    attr_reader :model_number
    attr_reader :model_description
    attr_reader :model_url
    attr_reader :serial_number
    attr_reader :software_version
    attr_reader :hardware_version

    def initialize(info)
      headers = {}
      info[0].split("\r\n").each do |line|
        matches = line.match(/^([\w\-]+):(?:\s)*(.*)$/)
        next unless matches
        headers[matches[1].upcase] = matches[2]
      end

      @description_url = headers['LOCATION']
      @server = headers['SERVER']
      @service_type = headers['ST']
      @usn = headers['USN']

      info = info[1]
      @port = info[1]
      @ip = info[2]

      get_description
    end

  protected

    def get_description
      response = Net::HTTP.get_response(URI.parse(description_url))
      doc = Nokogiri::XML(response.body)

      map = {
        name: 'friendlyName',
        manufacturer: 'manufacturer',
        model_name: 'modelName',
        model_number: 'modelNumber',
        model_description: 'modelDescription',
        model_url: 'modelURL',
        software_version: 'softwareVersion',
        hardware_version: 'hardwareVersion'
      }

      map.each do |key, xml_key|
        next unless node = doc.css("/root/device/#{xml_key}").first
        instance_variable_set("@#{key}".to_sym, node.inner_text)
      end

      @serial_number = (doc.css('/root/device/serialNumber').first || doc.css('/root/device/serialNum').first).inner_text
    end
  end
end

