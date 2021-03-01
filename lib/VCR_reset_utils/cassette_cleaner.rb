module CassetteCleaner
  def insert_cassette(name, options = {})
    current_cassette = VCR::Cassette.new(name, options)

    if current_cassette.recording? && configuration.default_cassette_options[:record] == :all && ENV["RECORD_VCR"] == "1"
      File.delete(current_cassette.file) if File.exist?(current_cassette.file)
    end

    super
  end
end