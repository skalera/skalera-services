require 'diplomat'
require 'securerandom'

module Skalera
  module Services
    class Errbit
      def self.configure(service_name)
        api_key(service_name)
      end

      def self.config
        Diplomat::Service.get('errbit')
      end

      def self.key_name(service_name)
        "#{service_name}/errbit/key"
      end

      def self.api_key(service_name)
        Diplomat.get(key_name(service_name))
      rescue Diplomat::KeyNotFound
        key = SecureRandom.hex(8)
        puts "created errbit key '#{key}' for service '#{service_name}'"
        Diplomat::Kv.put(key_name(service_name), key)
      end
    end
  end
end
