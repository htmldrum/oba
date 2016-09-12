RSpec.describe V0::BillSerializer do
  let(:resource) { create(:bill) }
  let(:bills) { sez(resource.bills, described_class) }
  specify 'bill' do
    expect(json.except('bills')).to eq('id' => resource.id,
                                       'value' => resource.value.as_json,
                                       'due_date' => resource.due_date.as_json,
                                       'created_at' => resource.created_at.as_json,
                                       'updated_at' => resource.updated_at.as_json)
  end
end
