require 'redis'

module Skalera
  module Services
    class Redis
      def self.instance(database=0)
        redis_config = Diplomat::Service.get('redis')

        redis = ::Redis.new(url: url(password, redis_config.Address, redis_config.ServicePort, database))
        at_exit { redis.quit }
        redis
      end

      def self.url(password, host, port, database)
        pwd = password ? "#{password}:" : ''
        "redis://#{pwd}#{host}:#{port}/#{database}"
      end

      def self.password
        Diplomat.get('redis/password')
      rescue Diplomat::KeyNotFound
        nil
      end
    end
  end
end
