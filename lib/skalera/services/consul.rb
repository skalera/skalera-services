require 'diplomat'

module Skalera
  module Services
    class Consul
      def self.configure(service_name)
        consul = ENV['CONSUL'] || 'consul'
        Diplomat.configuration.url = "http://#{consul}:8500"
        token = ENV['CONSUL_ACL_TOKEN']
        Diplomat.configuration.acl_token = token if token

        # force a lookup just to make a connection so we can bail out early if consul id down
        Diplomat.get("services/#{service_name}")
      rescue Diplomat::KeyNotFound
        Diplomat.put("services/#{service_name}", service_name)
      rescue Faraday::ConnectionFailed => e
        STDERR.puts("ERROR: could not lookup host #{consul}")
        raise e
      end
    end
  end
end
