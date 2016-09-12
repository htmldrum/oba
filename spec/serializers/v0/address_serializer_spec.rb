RSpec.describe V0::AddressSerializer do
  let(:resource) { create(:address) }
  specify 'address' do
    expect(json).to eq('id' => resource.id,
                       'address_line_1' => resource.address_line_1,
                       'address_line_2' => resource.address_line_2,
                       'city' => resource.city,
                       'state' => resource.state,
                       'zip' => resource.zip,
                       'country' => resource.country,
                       'created_at' => resource.created_at.as_json,
                       'updated_at' => resource.created_at.as_json)
  end
end
