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
