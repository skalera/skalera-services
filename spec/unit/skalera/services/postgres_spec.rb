require 'spec_helper'

describe Skalera::Services::Postgres do
  let(:config) { double(:config, Address: 'host', ServicePort: 1234) }
  let(:url) { 'postgres://user:password@host:1234/foobar' }

  it 'builds an url' do
    expect(Diplomat::Service).to receive(:get).with('postgres').and_return(config)
    expect(described_class).to receive(:key).with('user').and_return('user')
    expect(described_class).to receive(:key).with('password').and_return('password')

    expect(Sequel).to receive(:connect).with(url)
    expect(described_class).to receive(:at_exit)

    described_class.instance('foobar')
  end
end
