require 'influxdb'

module Skalera
  module Services
    class InfluxDB
      SERVICE_NAME = 'influxdb-8086'
      def self.instance(database)
        influxdb_config = Diplomat::Service.get(SERVICE_NAME)

        influxdb = ::InfluxDB::Client.new(database,
                                          host: influxdb_config.Address,
                                          port: influxdb_config.ServicePort,
                                          user: key('user'),
                                          password: key('password'))
        # does not need an at_exit, as the influx clients takes care of it
        influxdb
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: service not found: #{SERVICE_NAME}"
      end

      def self.key(key)
        Diplomat.get("influxdb/#{key}")
      end
    end
  end
end
