# Skalera::Services

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/skalera/services`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'skalera-services'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skalera-services

## Usage
Here is a sample use of the skalera-services gem:

```ruby
#!/usr/bin/env ruby

# make sure the program is invoked through bundle exec
exec('bundle', 'exec', $PROGRAM_NAME, *ARGV) unless ENV['BUNDLE_GEMFILE']

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

SERVICE_NAME = ENV['SERVICE_NAME'] || 'sample'
require 'skalera/services'

# configures consul, errbit & airbrake
Skalera::Services.bootstrap(SERVICE_NAME)

begin
  # run your stuff here...
  influx = Skalera::Services::InfluxDB.instance('metrics')
  redis = Skalera::Services::Redis.instance
  DB = Skalera::Services::Postgres.instance('postgres')
rescue => e
  STDERR.puts("#{e.class.name}: #{e.message}")
  STDERR.puts(e.backtrace)
  Airbrake.notify_or_ignore(e, cgi_data: ENV.to_hash)
  exit(1)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/skalera-services/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
