require 'diplomat'

module Skalera
  module Services
    class Consul
      def self.configure(service_name)
        consul = ENV['CONSUL'] || 'consul'
        Diplomat.configuration.url = "http://#{consul}:8500"
        # force a lookup just to make a connection so we can bail out early if consul id down
        Diplomat.get(service_name)
      rescue Diplomat::KeyNotFound
        Diplomat.put(service_name, service_name)
      rescue Faraday::ConnectionFailed => e
        STDERR.puts("ERROR: could not lookup host #{consul}")
        raise e
      end
    end
  end
end
