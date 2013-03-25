# Discover

Discover UPNP devices using SSDP with Ruby.

## Installation

*Unreleased*

## Usage

You can list devices with the command line:

``` shell
$ discover devices
IP Address      | Name            | Service Type
----------------|-----------------|-------------
10.0.1.7        | Sonos PLAY:3    | urn:schemas-upnp-org:device:ZonePlayer:1
10.0.1.9        | Sonos CONNECT   | urn:schemas-upnp-org:device:ZonePlayer:1
10.0.1.10       | Sonos PLAY:3    | urn:schemas-upnp-org:device:ZonePlayer:1
10.0.1.11       | Sonos PLAY:3    | urn:schemas-upnp-org:device:ZonePlayer:1
10.0.1.17       | Hue Bridge      | urn:schemas-upnp-org:device:basic:1
```
Run `discover help` for more CLI documentation.

Here are a few examples of discovering devices in Ruby:

``` ruby
# Find all UPNP devices
devices = Discover.devices

# Optionally specify a timeout in seconds
devices = Discover.devices(timeout: 1)

# Find the first of a given type
device = Discover.first(service_type: 'urn:schemas-upnp-org:device:ZonePlayer:1')

# Get attributes about a device
device.ip   #=> "10.0.1.11"
device.name #=> "Sonos PLAY:3"
```

## Contributing

See the [contributing guide](Contributing.markdown).
