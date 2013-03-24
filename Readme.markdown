# Discover

Discover UPNP devices with Ruby.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'discover'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install discover

## Usage

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
