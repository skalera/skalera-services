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
    described_class.add('service', 'host1', 'username1', 'password1')
    described_class.add('service', 'host2', 'username2', 'password2')
    expected = [%w(host1 username1 password1), %w(host2 username2 password2)]
    expect(described_class.for('service')).to eq(expected)
  end

  it 'handles missing service folder' do
    expect { described_class.for('foo') { fail } }.to_not raise_error
  end
end
