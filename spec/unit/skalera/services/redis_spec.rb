require 'spec_helper'

describe Skalera::Services::Redis do
  let(:config) { double(:config, Address: 'host', ServicePort: 1234) }
  let(:url) { 'redis://redis:password@host:1234/0' }

  it 'builds an url' do
    expect(Diplomat::Service).to receive(:get).with('redis').and_return(config)
    expect(described_class).to receive(:password).twice.and_return('password')

    expect(Redis).to receive(:new).with(url: url)
    expect(described_class).to receive(:at_exit)

    described_class.instance
  end
end
