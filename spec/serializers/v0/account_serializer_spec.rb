RSpec.describe V0::AccountSerializer do
  let(:resource) { create(:account, :with_bill) }
  let(:bills) { sez(resource.bills, V0::BillSerializer) }
  specify 'account' do
    expect(json.except('bills')).to eq('id' => resource.id,
                                       'account_type_name' => resource.account_type.name,
                                       'number'  => resource.number,
                                       'balance' => resource.balance.as_json,
                                       'limit' => resource.limit,
                                       'statement_date' => resource.statement_date.as_json,
                                       'points' => resource.points,
                                       'point_earn_rate' => resource.point_earn_rate,
                                       'created_at' => resource.created_at.as_json,
                                       'updated_at' => resource.updated_at.as_json)
  end
  specify 'bills' do
    expect(json['bills']).to eq(bills)
  end
end
