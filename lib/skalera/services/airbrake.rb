require 'airbrake'

module Skalera
  module Services
    class Airbrake
      def self.configure(service_name)
        api_key = Errbit.api_key(service_name)
        errbit_config = Errbit.config
        ::Airbrake.configure do |config|
          config.api_key = api_key
          config.host    = errbit_config.Address
          config.port    = errbit_config.ServicePort
          config.secure  = config.port == 443
        end
      end
    end
  end
end
