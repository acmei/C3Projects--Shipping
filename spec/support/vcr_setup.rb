require "rubygems"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :webmock # FALSIFY THE INTERNETS. MOCK THEM.
  # config.default_cassette_options = { :record => :once }
end
