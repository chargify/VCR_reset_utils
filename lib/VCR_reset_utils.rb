require 'VCR_reset_utils/version'
require 'VCR_reset_utils/reset'
require 'VCR_reset_utils/cassette_cleaner'
require 'VCR_reset_utils/configuration'
require 'rspec'
require 'vcr'

module VCRResetUtils
  require 'railtie' if defined?(Rails)

  VCRResetUtils.configure {}

  def self.skip
    return unless ENV['RECORD_VCR'] =~ /^(true|1)$/i

    VCRResetUtilsSkip.new.skip('VCRResetUtils.skip')
  end
end

class VCRResetUtilsSkip
  include RSpec::Core::Pending
end
