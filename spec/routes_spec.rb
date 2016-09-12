RSpec.describe 'v0', type: :routing do
  describe 'auth' do
    specify do
      expect(get: '/v0/auth').to route_to(controller: 'v0/authenticate', action: 'index')
    end
  end
  describe 'users' do
    specify do
      expect(post: '/v0/users').to route_to(controller: 'v0/users', action: 'create')
      expect(get: '/v0/users/1').to route_to(controller: 'v0/users', action: 'show', id: '1')
      expect(put: '/v0/users/1').to route_to(controller: 'v0/users', action: 'update', id: '1')
      expect(delete: '/v0/users/1').to route_to(controller: 'v0/users', action: 'destroy', id: '1')
    end
  end
  describe 'accounts' do
    specify do
      expect(post: '/v0/users/1/accounts').to route_to(controller: 'v0/accounts', action: 'create', user_id: '1')
      expect(get: '/v0/users/1/accounts').to route_to(controller: 'v0/accounts', action: 'index', user_id: '1')
      expect(get: '/v0/users/1/accounts/2').to route_to(controller: 'v0/accounts', action: 'show', user_id: '1',
                                                        id: '2')
      expect(put: '/v0/users/1/accounts/2').to route_to(controller: 'v0/accounts', action: 'update', user_id: '1',
                                                        id: '2')
      expect(delete: '/v0/users/1/accounts/2').to route_to(controller: 'v0/accounts', action: 'destroy', user_id: '1',
                                                           id: '2')
    end
  end
  describe 'addresses' do
    specify do
      expect(post: '/v0/users/1/addresses').to route_to(controller: 'v0/addresses', action: 'create', user_id: '1')
      expect(get: '/v0/users/1/addresses').to route_to(controller: 'v0/addresses', action: 'index', user_id: '1')
      expect(get: '/v0/users/1/addresses/2').to route_to(controller: 'v0/addresses', action: 'show', user_id: '1',
                                                         id: '2')
      expect(put: '/v0/users/1/addresses/2').to route_to(controller: 'v0/addresses', action: 'update', user_id: '1',
                                                         id: '2')
      expect(delete: '/v0/users/1/addresses/2').to route_to(controller: 'v0/addresses', action: 'destroy', user_id: '1',
                                                            id: '2')
    end
  end
  describe 'bills' do
    specify do
      expect(post: '/v0/users/1/accounts/2/bills').to route_to(controller: 'v0/bills', action: 'create',
                                                                user_id: '1',
                                                                account_id: '2')
      expect(get: '/v0/users/1/accounts/2/bills').to route_to(controller: 'v0/bills', action: 'index',
                                                               user_id: '1',
                                                               account_id: '2')
      expect(get: '/v0/users/1/accounts/2/bills/3').to route_to(controller: 'v0/bills', action: 'show',
                                                                 user_id: '1',
                                                                 account_id: '2',
                                                                 id: '3')
      expect(put: '/v0/users/1/accounts/2/bills/3').to route_to(controller: 'v0/bills', action: 'update',
                                                                 user_id: '1',
                                                                 account_id: '2',
                                                                 id: '3')
      expect(delete: '/v0/users/1/accounts/2/bills/3').to route_to(controller: 'v0/bills', action: 'destroy',
                                                                    user_id: '1',
                                                                    account_id: '2',
                                                                    id: '3')
    end
  end
end
