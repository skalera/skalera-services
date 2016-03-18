require 'spec_helper'

describe Skalera::Services::Credentials do
  before :all do
    @consul = Service.new('consul', 'agent -dev -advertise 127.0.0.1')
    @consul.start
  end

  after :all do
    @consul.stop
  end

  it 'can add new credentials' do
    described_class.add('service', 'host', 'username', 'password')
    expect(described_class.for('service')).to eq([%w(host username password)])
  end

  it 'handles missing service folder' do
    expect { described_class.for('foo') { fail } }.to_not raise_error(Diplomat::KeyNotFound)
  end
end
