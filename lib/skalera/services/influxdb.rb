require 'influxdb'

module Skalera
  module Services
    class InfluxDB
      def self.instance(database)
        influxdb_config = Diplomat::Service.get('influxdb-8086')

        influxdb = ::InfluxDB::Client.new(database,
                                          host: influxdb_config.Address,
                                          port: influxdb_config.ServicePort,
                                          user: key('user'),
                                          password: key('password'))
        # does not need an at_exit, as the influx clients takes care of it
        influxdb
      end

      def self.key(key)
        Diplomat.get("influxdb/#{key}")
      end
    end
  end
end
