require 'sequel'

module Skalera
  module Services
    class Postgres
      def self.instance(database)
        postgres_config = Diplomat::Service.get('postgres')

        host = postgres_config.Address
        port = postgres_config.ServicePort

        url = "postgres://#{key('user')}:#{key('password')}@#{host}:#{port}/#{database}"
        db = ::Sequel.connect(url)
        at_exit { db.disconnect }
        db
      end

      def self.key(key)
        Diplomat.get("postgres/#{key}")
      end
    end
  end
end
