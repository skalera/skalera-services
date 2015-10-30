require 'spec_helper'

describe Skalera::Services::Credentials do
  before :all do
    @consul = Service.new('consul', 'agent -server -bootstrap -data-dir data')
    @consul.start
  end

  after :all do
    @consul.stop
  end

  it 'can add new credentials' do
    described_class.add('service', 'host', 'username', 'password')
    expect(described_class.for('service')).to eq([%w(host username password)])
  end
end
