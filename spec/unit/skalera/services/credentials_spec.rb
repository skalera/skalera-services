require 'spec_helper'

describe Skalera::Services::Credentials do
  it 'works when the key is missing' do
    expect(Diplomat::Kv).to receive(:get).with('credentials/foobar', recurse: true).and_raise(Diplomat::KeyNotFound)

    expect { described_class.for('foobar') }.to_not raise_error
  end
end
