RSpec.shared_context 'request' do
  let(:limit) { 10 }
  let(:page) { 1 }
  let!(:resource) { create described_class.name.underscore.to_sym }
  let!(:resources) do
    if described_class == User
      [resource, valid_user, *create_list(described_class.name.underscore.to_sym, limit)]
    else
      [resource, *create_list(described_class.name.underscore.to_sym, limit)]
    end
  end
  let(:headers) { {} }
end
