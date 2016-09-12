RSpec.shared_examples 'json_schema_index' do
  subject do
    get "/v0/#{described_class.name.underscore.pluralize}", {}, headers
  end
  specify do
    subject
    expect(response).to be_success
    expect(response).to match_response_schema(described_class.name.underscore.pluralize)
  end
end
