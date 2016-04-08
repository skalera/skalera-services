require 'sequel'

module Skalera
  module Services
    class Postgres
      SERVICE_NAME = 'postgres'
      def self.instance(database)
        postgres_config = Diplomat::Service.get(SERVICE_NAME)

        host = postgres_config.Address
        port = postgres_config.ServicePort

        url = "postgres://#{key('user')}:#{key('password')}@#{host}:#{port}/#{database}"
        db = ::Sequel.connect(url)
        at_exit { db.disconnect }
        db
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: service not found: #{SERVICE_NAME}"
      end

      def self.key(key)
        Diplomat.get("postgres/#{key}")
      end
    end
  end
end
