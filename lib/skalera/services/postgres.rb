require 'uri'
require 'sequel'

module Skalera
  module Services
    class Postgres
      SERVICE_NAME = 'postgres'
      def self.instance(database)
        if ENV['SKALERA_DB_URL']
          url = ENV['SKALERA_DB_URL']
        else
          postgres_config = Diplomat::Service.get(SERVICE_NAME)

          uri = URI('postgres:/')
          uri.host = postgres_config.Address
          uri.port = postgres_config.ServicePort
          uri.user = key('user')
          uri.password = key('password')
          uri.path = "/#{database}"
          url = uri.to_s
        end

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
