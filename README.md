# Linx

**WIP:** A simple UDP client for [InfluxDB](https://influxdb.com)

## Installation

**When** [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add linx to your list of dependencies in `mix.exs`:

        def deps do
          [{:linx, "~> 0.0.1"}]
        end

  2. Ensure linx is started before your application:

        def application do
          [applications: [:linx]]
        end

## Usage

**TODO**

## References

* [Line Protocol Syntax](https://influxdb.com/docs/v0.9/write_protocols/write_syntax.html)
* [InfluxDB UDP](https://influxdb.com/docs/v0.9/write_protocols/udp.html)

## Testing

Just run

    $ mix test

## Contributing

1. Fork it ( https://github.com/jnbt/linx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
