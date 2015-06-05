require 'redis'

module Skalera
  module Services
    class Redis
      def self.instance(database=0)
        redis_config = Diplomat::Service.get('redis')

        options = { host: redis_config.Address, port: redis_config.ServicePort, database: database }
        pwd = password
        options[:password] = pwd if pwd

        redis = ::Redis.new(options)
        at_exit { redis.quit }
        redis
      end

      def self.password
        Diplomat.get('redis/password')
      rescue Diplomat::KeyNotFound
        nil
      end
    end
  end
end
