RSpec.shared_examples 'json_schema_show' do
  subject do
    get "/v0/#{described_class.name.underscore.pluralize}/#{resources.first.id}", {}, headers
  end
  specify do
    subject
    expect(response).to be_success
    expect(response).to match_response_schema(described_class.name.underscore)
  end
end
