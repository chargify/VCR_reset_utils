require 'VCR_reset_utils'
require 'rails'

module VCRResetUtils
  class Railtie < Rails::Railtie
    railtie_name :VCR_reset_utils

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
