require 'skalera/services/airbrake'
require 'skalera/services/consul'
require 'skalera/services/credentials'
require 'skalera/services/controllers'
require 'skalera/services/errbit'
require 'skalera/services/influxdb'
require 'skalera/services/postgres'
require 'skalera/services/redis'
require 'skalera/services/version'

module Skalera
  module Services
    def bootstrap(service_name)
      Skalera::Services::Consul.configure(service_name)
      Skalera::Services::Errbit.configure(service_name)
      Skalera::Services::Airbrake.configure(service_name)
    end

    module_function :bootstrap
  end
end
