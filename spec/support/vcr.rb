require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_casettes'
  c.hook_into            :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end