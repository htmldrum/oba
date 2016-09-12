RSpec.shared_context 'authentication' do
  let!(:valid_user) { create(:user, :valid) }
  let!(:token) { "Token #{valid_user.auth_token}" }
  let!(:headers) { { 'Authorization' => token } }
end
