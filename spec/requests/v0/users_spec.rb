RSpec.describe User, type: :request do
  include_context 'request'
  include_context 'authentication'

  describe '#show' do
    let(:path) { "/v0/users/#{resource.id}" }
    let(:params) { nil }

    it_behaves_like 'request_show'
  end

  describe '#create' do
    let(:user) do
      build(:user)
        .attributes
        .delete_if{|k,v| k != "pin"}
    end
    let(:params) { { user: user } }
    subject { post '/v0/users', params, headers }
    specify do
      expect { subject }
        .to change(User, :count).by(1)
        .to change(Account, :count).by(1)
        .to change(Address, :count).by(1)
      expect(response).to be_success
      expect(json['user']['id']).to eq(user['id'])
    end
  end

  describe '#destroy' do
    subject { delete "/v0/users/#{resources.last.id}", {}, headers }
    specify do
      expect { subject }.to change(User, :count).by(-1)
      expect(response).to be_success
      expect(response.status).to eq 204
    end
  end

  context Account do
    let(:user) { User.first }
    let!(:accounts) { create_list(:account, limit, :with_bill, user: user) }
    describe '#index' do
      subject! { get "/v0/users/#{user.id}/accounts", { page: page, limit: limit }, headers }
      specify do
        subject
        expect(response).to be_success
        expect(json['accounts'].length).to eq(limit)
        expect(json['meta']['total']).to eq(user.accounts.length)
        expect(json['meta']['page']).to eq(page)
        expect(json['meta']['limit']).to eq(limit)
      end
    end
    describe '#show' do
      subject! { get "/v0/users/#{user.id}/accounts/#{accounts.first.id}", { page: page, limit: limit }, headers }
      specify do
        expect(response).to be_success
        expect(json['account']['id']).to eq(accounts.first.id)
      end
    end
    describe '#create' do
      let(:account) do
        a = build(:account)
        a
          .attributes
          .except('created_at',
                  'updated_at',
                  'id')
          .merge!(account_type_name: a.account_type.name)
          .merge!(bills: build_list(:bill, 1, account: nil)
                   .map!{|b| b.attributes.except('id', 'created_at', 'updated_at')})
      end
      let(:params) { { account: account } }
      subject { post "/v0/users/#{user.id}/accounts", params, headers }
      specify do
        expect { subject }
          .to change(Account, :count).by(1)
               .and change(Bill, :count).by(1)
        expect(response).to be_success
      end
    end
    describe '#update' do
      let(:account) do
        build(:account)
          .attributes
          .except('created_at',
                  'updated_at',
                  'id')
      end
      let(:old) { accounts.first.number }
      let(:params) { { account: account } }
      subject { put "/v0/users/#{user.id}/accounts/#{accounts.first.id}", params, headers }
      specify do
        expect { subject }
          .to change { accounts.first.reload.number }.from(old).to(account['number'])
        expect(response).to be_success
      end
    end
    describe '#destroy' do
      subject { delete "/v0/users/#{user.id}/accounts/#{accounts.last.id}", {}, headers }

      specify do
        expect { subject }.to change(Account, :count).by(-1)
        expect(response).to be_success
        expect(response.status).to eq 204
      end
    end

    context Bill do
      let!(:account){ accounts.first }
      let!(:bill){ account.bills.first}
      let!(:bills){ [bill, *create_list(:bill, 10, account: account)] }
      describe '#index' do
        subject! { get "/v0/users/#{user.id}/accounts/#{account.id}/bills", { page: page, limit: limit }, headers }
        specify do
          subject
          expect(response).to be_success
          expect(json['bills'].length).to eq(limit)
          expect(json['meta']['total']).to eq(account.bills.length)
          expect(json['meta']['page']).to eq(page)
          expect(json['meta']['limit']).to eq(limit)
        end
      end
      describe '#show' do
        subject! { get "/v0/users/#{user.id}/accounts/#{accounts.first.id}", { page: page, limit: limit }, headers }
        specify do
          expect(response).to be_success
          expect(json['account']['id']).to eq(accounts.first.id)
        end
      end
      describe '#create' do
        let(:nbill) do
          build(:bill)
            .attributes
            .except('created_at',
                    'updated_at',
                    'id')
        end
        let(:params) { { bill: nbill } }
        subject { post "/v0/users/#{user.id}/accounts/#{account.id}/bills", params, headers }
        specify do
          expect { subject }
            .to change(Bill, :count).by(1)
          expect(response).to be_success
        end
      end
      describe '#update' do
        let(:ubill) do
          build(:bill)
            .attributes
            .except('created_at',
                    'updated_at',
                    'id')
        end
        let(:old) { bill.value }
        let(:params) { { bill: ubill } }
        subject { put "/v0/users/#{user.id}/accounts/#{accounts.first.id}/bills/#{bill.id}", params, headers }
        specify do
          expect { subject }
            .to change { bill.reload.value }.from(old).to(ubill['value'])
          expect(response).to be_success
        end
      end
      describe '#destroy' do
        subject { delete "/v0/users/#{user.id}/accounts/#{accounts.last.id}", {}, headers }

        specify do
          expect { subject }.to change(Account, :count).by(-1)
          expect(response).to be_success
          expect(response.status).to eq 204
        end
      end
    end
  end

  context Address do
    let(:user) { User.first }
    let!(:addresses) { create_list(:address, limit, user: user) }
    describe '#index' do
      subject! { get "/v0/users/#{user.id}/addresses", { page: page, limit: limit }, headers }
      specify do
        subject
        expect(response).to be_success
        expect(json['addresses'].length).to eq(limit)
        expect(json['meta']['total']).to eq(user.addresses.length)
        expect(json['meta']['page']).to eq(page)
        expect(json['meta']['limit']).to eq(limit)
      end
    end
    describe '#show' do
      subject! { get "/v0/users/#{user.id}/addresses/#{addresses.first.id}", { page: page, limit: limit }, headers }
      specify do
        subject
        expect(response).to be_success
        expect(json['address']['id']).to eq(addresses.first.id)
      end
    end
    describe '#create' do
      let(:address) do
        build(:address)
          .attributes
          .except('created_at',
                  'updated_at',
                  'id')
      end
      let(:params) { { address: address } }
      subject { post "/v0/users/#{user.id}/addresses", params, headers }
      specify do
        expect { subject }
          .to change(Address, :count).by(1)
        expect(response).to be_success
      end
    end
    describe '#update' do
      let(:address) do
        build(:address)
          .attributes
          .except('created_at',
                  'updated_at',
                  'id')
      end
      let(:old) { addresses.first.city }
      let(:params) { { address: address } }
      subject { put "/v0/users/#{user.id}/addresses/#{addresses.first.id}", params, headers }
      specify do
        expect { subject }
          .to change { addresses.first.reload.city }.from(old).to(address['city'])
        expect(response).to be_success
      end
    end
    describe '#destroy' do
      subject { delete "/v0/users/#{user.id}/addresses/#{addresses.last.id}", {}, headers }

      specify do
        expect { subject }.to change(Address, :count).by(-1)
        expect(response).to be_success
        expect(response.status).to eq 204
      end
    end
  end
end
