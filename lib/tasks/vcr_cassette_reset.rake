namespace :vcr do
  desc 'reset the vcr cassettes for a given key_word. Usage: rake vcr:reset["mykey_word"]'
  task :reset, [:key_word] => :environment do |_, args|
    vcr_reset = VCRResetUtils::Reset.new(args[:key_word])
    ENV["RECORD_VCR"] = "1"
    if vcr_reset.allowed_key_word?
      warn "============ VCR's reset ============"
      vcr_reset.call
      warn ""
      warn "RUN TEST WITH RESET VCR OPTION:"
      warn "RECORD_VCR=1 bundle exec rspec <path_to_test>"
      warn "============ END ============"
    else
      warn "KEY WORD NOT ALLOWED (use VCRResetUtils.configure)"
    end

    ENV["RECORD_VCR"] = "0"
  end

  task :files_to_reset, [:key_word] => :environment do |_, args|
    vcr_reset = VCRResetUtils::Reset.new(args[:key_word])

    if vcr_reset.allowed_key_word?
      warn "============ Files to rerun ============"
      vcr_reset.files_to_rerun
      warn "============ END ============"
    else
      warn "KEY WORD NOT ALLOWED (use VCRResetUtils.configure)"
    end
  end

  task :files_with_tests_to_skip, [:key_word] => :environment do |_, args|
    vcr_reset = VCRResetUtils::Reset.new(args[:key_word])
    if vcr_reset.allowed_key_word?
      warn "============ Files with tests to skip ============"
      vcr_reset.files_with_tests_to_skip
      warn "============ END ============"
    end
  end

  task key_words: :environment do
    warn "============ Key words ============"
    warn VCRResetUtils::Reset.key_words
    warn "============ END ============"
  end
end
