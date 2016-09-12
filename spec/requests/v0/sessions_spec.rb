RSpec.describe V0::SessionsController, type: :request do
  # Create: Create auth_token
  describe '#create' do
    let(:pin) do
      create(:user)
        .attributes['pin']
    end
    let(:params) { { pin: pin } }
    subject { post '/v0/sessions', params, {} }
    specify do
      # Expect to change the user's auth_token from nil to something
      expect { subject }
      expect(response).to be_success
      expect(json['user']['id']).to eq(user['id'])
    end
  end

  # Destroy: Invalidate auth_token
  describe '#destroy' do
    let(:user){ create(:user, :valid) }
    subject { delete "/v0/sessions", {}, {'Authorization' => "Token #{user.auth_token}"} }
    specify do
      # Expect to change the user's token from token to nil
      expect { subject }.to change(User, :count).by(-1)
      expect(response).to be_success
      expect(response.status).to eq 204
    end
  end
end
