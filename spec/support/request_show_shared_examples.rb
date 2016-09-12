RSpec.shared_examples 'request_show' do
  subject! { get "/v0/#{described_class.name.underscore.pluralize}/#{resources.first.id}", {}, headers }
  specify do
    expect(response).to be_success
    expect(json[described_class.name.underscore]['id']).to eq(resource_from_path(path))
    try(:show_assertions)
  end
end
