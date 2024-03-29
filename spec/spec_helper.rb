require 'json'
require 'require_all'

require_all __dir__+'/../src'

# see: https://github.com/colszowka/simplecov

require 'simplecov'
SimpleCov.start

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def json_fixture fname
  JSON.parse IO.read(__dir__+'/fixtures/'+fname)
end

def fixture_data
  Loader.load_json_data(__dir__+'/fixtures/')
end