require 'vcr'
VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_casettes'
  c.stub_with            :webmock
end