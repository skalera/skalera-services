require 'spec_helper'

describe Skalera::Services::Controllers do
  before :all do
    @consul = Service.new('consul', 'agent -server -bootstrap -data-dir data')
    @consul.start
  end

  after :all do
    @consul.stop
  end

  it 'can add a new controller' do
    described_class.add('e18c3db6-04fb-409f-83d9-4741a00ae153', 'host', 'port')
    expect(described_class.for('e18c3db6-04fb-409f-83d9-4741a00ae153')).to eq(%w(host port))
  end
end
