module VCRResetUtils
  class << self
    attr_accessor :configuration
  end

  def self.configure
    VCR.configure do |c|
      c.default_cassette_options = { record: :all } if ENV['RECORD_VCR'] =~ /^(true|1)$/i
    end

    VCR.extend(CassetteCleaner)

    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :allow_key_words_without_dictionary, :key_words_dictionary

    def initialize
      @allow_key_words_without_dictionary = true
      @key_words_dictionary = {
        cybersource: '"cybersource\\|cyber_source\\|cyber source"',
        stripe: 'stripe',
        moneris: 'moneris | grep -v moneris_us'
      }
    end
  end
end
