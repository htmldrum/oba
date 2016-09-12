require 'rails_helper'
require 'spec_helper'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.curl_headers_to_filter = %w(cookie host Cookie Host)
  config.api_name = 'onefill_pud'
  config.curl_host = 'https://quiet-bayou-88094.herokuapp.com'
  config.request_headers_to_include = %w(Accept Content-Type)
  config.response_headers_to_include = %w(Accept Content-Type)
end
