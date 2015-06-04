require 'redis'

module Skalera
  module Services
    class Redis
      def self.instance(service_name)
        redis_config = Diplomat::Service.get('redis')
        # TODO: fetch password and database from consul using service_name
        options = { host: redis_config.Address, port: redis_config.ServicePort }
        pwd = password(service_name)
        options[:password] = pwd if pwd
        redis = ::Redis.new(options)
        at_exit { redis.quit }
        redis
      end

      def self.password(service_name)
        Diplomat.get("#{service_name}/redis/password")
      rescue Diplomat::KeyNotFound
        nil
      end
    end
  end
end
