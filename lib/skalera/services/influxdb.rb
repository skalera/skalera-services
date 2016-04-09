require 'uri'
require 'influxdb'

module Skalera
  module Services
    class InfluxDB
      SERVICE_NAME = 'influxdb-8086'
      def self.instance(database)
        url = ENV['SKALERA_INFLUXDB_URL']
        if url
          uri = URI(url)
          host = uri.host
          port = uri.port || '8086'
          user = uri.user
          password = uri.password
        else
          influxdb_config = Diplomat::Service.get(SERVICE_NAME)
          host = influxdb_config.Address
          port = influxdb_config.ServicePort
          user = key('user')
          password = key('password')
        end

        ::InfluxDB::Client.new(database, host: host, port: port, user: user, password: password)
      rescue URI::InvalidURIError => e
        STDERR.puts "ERROR: could not parse URL: #{e.message}"
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: service not found: #{SERVICE_NAME}"
      end

      def self.key(key)
        Diplomat.get("influxdb/#{key}")
      end
    end
  end
end
