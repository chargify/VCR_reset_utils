require 'spec_helper'

describe 'VCRResetUtils.configuration' do
  it 'allow_key_words_without_dictionary' do
    expect(VCRResetUtils.configuration.allow_key_words_without_dictionary).to eq(true)
  end

  it 'key_words_dictionary' do
    expect(VCRResetUtils.configuration.key_words_dictionary).to eq(
      {
        cybersource: '"cybersource\\|cyber_source\\|cyber source"',
        stripe: 'stripe',
        moneris: 'moneris | grep -v moneris_us'
      }
    )
  end
end
