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
  redis = Skalera::Services::Redis.instance(SERVICE_NAME)

  redis.set('key', 'a value')
  value = redis.get('key')
  puts "got 'key' from redis: #{value}"
rescue => e
  STDERR.puts(e)
  Airbrake.notify_or_ignore(e, cgi_data: ENV.to_hash)
  exit(1)
end
