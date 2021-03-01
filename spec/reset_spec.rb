require 'spec_helper'

describe VCRResetUtils::Reset do
  it '#key_words' do
    expect(described_class.key_words).to be_kind_of(Array)
  end

  it '#files_with_tests_to_skip' do
    reset = described_class.new('stripe')
    expect(reset).to receive(:system).with(
      'git grep -i --files-with-matches VCRResetUtils.skip | xargs grep -i stripe | grep -v "vcr_utils/reset_spec.rb\|rails_helper.rb" | cut -d : -f 1 | uniq | grep .rb'
    )
    reset.files_with_tests_to_skip
  end

  describe '#search_word' do
    describe 'where allow_key_words_without_dictionary is false' do
      before do
        VCRResetUtils.configure do |config|
          config.allow_key_words_without_dictionary = false
          config.key_words_dictionary = { authorize_net: '"authorizenet\\|authorize_net\\|authorize net"' }
        end
      end

      it 'key word is on the list' do
        expect(described_class.new('authorize_net').send(:search_word)).to eq(
          '"authorizenet\\|authorize_net\\|authorize net"'
        )
      end

      it 'key word is not on the list' do
        expect(described_class.new('test123321').send(:search_word)).to eq(nil)
      end
    end

    describe 'where allow_key_words_without_dictionary is true' do
      before do
        VCRResetUtils.configure do |config|
          config.key_words_dictionary = { moneris: 'moneris | grep -v moneris_us' }
          config.allow_key_words_without_dictionary = true
        end
      end

      it 'key word is on the list' do
        expect(described_class.new('moneris').send(:search_word)).to eq(
          'moneris | grep -v moneris_us'
        )
      end

      it 'key word is not on the list' do
        expect(described_class.new('test123321').send(:search_word)).to eq('test123321')
      end
    end
  end

  it '#search_files_commend' do
    VCRResetUtils.configure do |config|
      config.key_words_dictionary = { payment_express: '"payment_express\\|payment express\\|windcave"' }
    end

    expect(described_class.new('payment_express').send(:search_files_commend)).to eq(
      'git grep -i --files-with-matches "VCR\.use_cassette\|vcr_base_path\|vcr_path\|cassette_name" | xargs grep -i "payment_express\|payment express\|windcave" | grep -v "vcr_utils/reset_spec.rb\|rails_helper.rb" | cut -d : -f 1 | uniq | grep .rb'
    )
  end

  it '#call' do
    reset = described_class.new('stripe')
    expect(reset).to receive(:system).with(
      'git grep -i --files-with-matches "VCR\.use_cassette\|vcr_base_path\|vcr_path\|cassette_name" | xargs grep -i stripe | grep -v "vcr_utils/reset_spec.rb\|rails_helper.rb" | cut -d : -f 1 | uniq | grep .rb | xargs bundle exec rspec'
    )
    reset.call
  end

  it '#files_to_rerun' do
    VCRResetUtils.configure do |config|
      config.key_words_dictionary = { cybersource: '"cybersource\\|cyber_source\\|cyber source"' }.freeze
    end

    reset = described_class.new('cybersource')
    expect(reset).to receive(:system).with(
      'git grep -i --files-with-matches "VCR\.use_cassette\|vcr_base_path\|vcr_path\|cassette_name" | xargs grep -i "cybersource\\|cyber_source\\|cyber source" | grep -v "vcr_utils/reset_spec.rb\|rails_helper.rb" | cut -d : -f 1 | uniq | grep .rb'
    )
    reset.files_to_rerun
  end

  describe '#allowed_key_word?' do
    describe 'where allow_key_words_without_dictionary is false' do
      before do
        VCRResetUtils.configure do |config|
          config.key_words_dictionary = { litle: 'litle' }
          config.allow_key_words_without_dictionary = false
        end
      end

      it 'key word is not on the list' do
        expect(described_class.new('test123321').allowed_key_word?).to eq(false)
      end

      it 'key word is on the list' do
        expect(described_class.new('litle').allowed_key_word?).to eq(true)
      end
    end

    describe 'where ALLOW_KEY_WORDS_WITHOUT_DICTIONARY is true' do
      before do
        VCRResetUtils.configure do |config|
          config.key_words_dictionary = { adyen: 'adyen' }
          config.allow_key_words_without_dictionary = true
        end
      end

      it 'key word is not on the list' do
        expect(described_class.new('test123321').allowed_key_word?).to eq(true)
      end

      it 'key word is on the list' do
        expect(described_class.new('adyen').allowed_key_word?).to eq(true)
      end
    end
  end
end
