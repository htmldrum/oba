RSpec.describe V0::UserSerializer do
  let(:resource) { create(:user, :valid, :with_account, :with_address) }
  let(:accounts) { sez(resource.accounts, V0::AccountSerializer) }
  let(:addresses) { sez(resource.addresses, V0::AddressSerializer) }
  let(:serializer_options) do
    { bills: true }
  end
  specify 'user' do
    expect(json
            .except('accounts', 'addresses')).to eq('id' => resource.id,
                                                    'first_name' => resource.first_name,
                                                    'last_name' => resource.last_name,
                                                    'email' => resource.email,
                                                    'created_at' => resource.created_at.as_json,
                                                    'updated_at' => resource.updated_at.as_json)
    expect(json['accounts']).to eq(accounts)
    expect(json['addresses']).to eq(addresses)
  end
end
