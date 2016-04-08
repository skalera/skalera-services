require 'diplomat'

module Skalera
  module Services
    class Controllers
      def self.for(controller_uuid)
        controllers = Diplomat::Kv.get("controllers/#{controller_uuid}", recurse: true)
        host = extract(controllers, 'address')
        port = extract(controllers, 'port')
        [host['address'], port['port']]
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: key not found: controllers/#{controller_uuid}"
      end

      def self.extract(controllers, field)
        result = {}
        controllers.select { |c| c[:key].match(%r{/#{field}}) }.each do |hash|
          host = hash[:key].sub(%r{controllers/}, '').split('/')[1]
          result[host] = hash[:value]
        end
        result
      end

      def self.add(controller_uuid, host, port)
        Diplomat::Kv.put("controllers/#{controller_uuid}/address", host)
        Diplomat::Kv.put("controllers/#{controller_uuid}/port", port)
      end
    end
  end
end
