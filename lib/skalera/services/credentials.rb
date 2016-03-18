require 'diplomat'

module Skalera
  module Services
    class Credentials
      def self.for(service_name)
        creds = Diplomat::Kv.get("credentials/#{service_name}", recurse: true)

        users = extract(creds, service_name, 'username')
        passwords = extract(creds, service_name, 'password')

        users.map do |host, username|
          password = passwords[host]
          if host.nil? || username.nil? || password.nil?
            # TODO: use logging
            STDERR.puts "host: #{host}, username: #{username}, password: '#{password}'"
            next
          end
          yield host, username, password if block_given?
          [host, username, password]
        end.compact # in case there is an error
      rescue Diplomat::KeyNotFound
        STDERR.puts "ERROR: key not found: credentials/#{service_name}"
      end

      def self.extract(creds, key, field)
        result = {}
        # TODO: handle errors when decoding the contents
        creds.select { |c| c[:key].match(%r{/#{field}$}) }.each do |hash|
          host = hash[:key].match(%r{#{key}/(.+)/#{field}})[1]
          result[host] = hash[:value]
        end
        result
      end

      def self.add(service_name, host, username, password)
        Diplomat::Kv.put("credentials/#{service_name}/#{host}/username", username)
        Diplomat::Kv.put("credentials/#{service_name}/#{host}/password", password)
      end
    end
  end
end
