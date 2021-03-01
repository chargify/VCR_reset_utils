module VCRResetUtils
  class Reset
    def initialize(key_word)
      @key_word = key_word
    end

    def self.key_words
      VCRResetUtils.configuration.key_words_dictionary.keys.sort
    end

    def files_with_tests_to_skip
      system(
        "git grep -i --files-with-matches VCRResetUtils.skip | xargs grep -i " + search_word +
          " | grep -v vcr_utils/reset_spec.rb | cut -d : -f 1 | uniq | grep .rb"
      )
    end

    def call
      system(search_files_commend + " | xargs bundle exec rspec")
    end

    def files_to_rerun
      system(search_files_commend)
    end

    def allowed_key_word?
      VCRResetUtils.configuration.allow_key_words_without_dictionary ||
        VCRResetUtils::Reset.key_words.include?(@key_word.to_sym)
    end

    private

    def search_files_commend
      'git grep -i --files-with-matches "VCR\.use_cassette\|vcr_base_path\|vcr_path\|cassette_name" ' +
        "| xargs grep -i " + search_word + " | grep -v vcr_utils/reset_spec.rb | cut -d : -f 1 | uniq | grep .rb"
    end

    def search_word
      return @key_word if !VCRResetUtils::Reset.key_words.include?(@key_word.to_sym) &&
                          VCRResetUtils.configuration.allow_key_words_without_dictionary

      VCRResetUtils.configuration.key_words_dictionary[@key_word.to_sym]
    end
  end
end
