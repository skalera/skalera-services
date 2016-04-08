require 'redis'

module Skalera
  module Services
    class Redis
      SERVICE_NAME = 'redis'
      def self.instance(database = 0)
        redis_config = Diplomat::Service.get(SERVICE_NAME)

        redis = ::Redis.new(url: url(password, redis_config.Address, redis_config.ServicePort, database))
        at_exit { redis.quit }
        redis
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: service not found: #{SERVICE_NAME}"
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
