require 'uri'
require 'redis'

module Skalera
  module Services
    class Redis
      SERVICE_NAME = 'redis'
      def self.instance(database = 0)
        if ENV['SKALERA_REDIS_URL']
          redis_url = ENV['SKALERA_REDIS_URL']
        else
          redis_config = Diplomat::Service.get(SERVICE_NAME)
          uri = URI('redis:/')
          uri.host = redis_config.Address
          uri.port = redis_config.ServicePort
          uri.path = "/#{database}"
          if password
            uri.user = 'redis' # this is not used, but URI require a user when you have a password
            uri.password = password
          end

          redis_url = uri.to_s
        end

        redis = ::Redis.new(url: redis_url)
        at_exit { redis.quit }
        redis
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: service not found: #{SERVICE_NAME}"
      end

      def self.password
        Diplomat.get('redis/password')
      rescue Diplomat::KeyNotFound
        nil
      end
    end
  end
end
