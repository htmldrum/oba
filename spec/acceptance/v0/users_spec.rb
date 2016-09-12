resource User, type: :acceptance do
  FACTORY_TRAITS = [:with_account, :with_address].freeze
  include_context 'acceptance'
  include_context 'authentication'
  header 'Authorization', :token

  post '/v0/users' do
    let(:nuser) do
      u = build(:user, :valid)
          .attributes
          .except('created_at', 'updated_at')
      u['accounts'] = build_list(:account, 1, :with_bill).map! do |ac|
        ac
          .attributes
          .except('user_id')
          .merge!(account_type_name: ac.account_type.name)
          .merge!(bills: build_list(:bill, 1, account: nil)
                   .map!{|b| b.attributes.except('id', 'created_at', 'updated_at', 'account_id')})
      end
      u['addresses'] = build_list(:address, 1).map! do |ad|
        ad
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
      end
      u
    end
    let(:raw_post) { { user: nuser }.to_json }

    parameter :id, 'Id', required: true, scope: :user
    parameter :auth_token, 'Auth token', required: true, scope: :user
    parameter :first_name, 'First Name', scope: :user
    parameter :last_name, 'Last Name', scope: :user
    parameter :email, 'Email', scope: :user

    response_field :id, 'Id', scope: :user, 'Type' => 'Number'
    response_field :first_name, 'First name', scope: :user, 'Type' => 'String'
    response_field :last_name, 'Last name', scope: :user, 'Type' => 'String'
    response_field :email, 'Email', scope: :user, 'Type' => 'String'
    response_field :created_at, 'Created At', scope: :user, 'Type' => 'String'
    response_field :updated_at, 'Updated At', scope: :user, 'Type' => 'String'

    example_request 'create' do
      explanation 'Create a user'
      expect(status).to eq(201)
      client.get(URI.parse(response_headers['location']).path, {}, headers)
      expect(status).to eq(200)
    end
  end
  get '/v0/users/:id' do
    include_context 'acceptance_show'
  end
  put '/v0/users/:id' do
    let(:id) { users.second.id }
    let(:uuser) do
      build(:user, :valid)
        .attributes
        .except('id', 'created_at', 'updated_at')
    end
    let(:raw_post) { { user: uuser }.to_json }

    parameter :auth_token, 'Auth token', scope: :user
    parameter :first_name, 'First Name', scope: :user
    parameter :last_name, 'Last Name', scope: :user
    parameter :email, 'Email', scope: :user

    response_field :id, 'Id', scope: :user, 'Type' => 'Number'
    response_field :first_name, 'First name', scope: :user, 'Type' => 'String'
    response_field :last_name, 'Last name', scope: :user, 'Type' => 'String'
    response_field :email, 'Email', scope: :user, 'Type' => 'String'
    response_field :created_at, 'Created At', scope: :user, 'Type' => 'String'
    response_field :updated_at, 'Updated At', scope: :user, 'Type' => 'String'

    example_request 'put' do
      expect(status).to eq(200)
    end
  end
  delete '/v0/users/:id' do
    let(:id) { users.last.id }
    example_request 'delete' do
      expect(status).to eq(204)
    end
  end
    resource 'Users::Accounts', type: :acceptance do
    let(:user) { users.first }
    get '/v0/users/:user_id/accounts' do
      parameter :page, 'Current page of results. Default: 1'
      parameter :limit, 'Results per page. Default: 20.'
      let(:user_id) { user.id }
      let(:page) { 1 }
      let(:limit) { 20 }
      example_request 'index' do
        expect(status).to eq(200)
        expect(json['accounts'].length).to eq(user.accounts.length)
      end
    end

    get '/v0/users/:user_id/accounts/:id' do
      let(:user_id) { user.id }
      let(:id) { user.accounts.first.id }
      example_request 'show' do
        expect(status).to eq(200)
      end
    end

    post '/v0/users/:user_id/accounts' do
      let(:user_id) { user.id }
      let(:account) do
        a = build(:account)
        a
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
          .merge!(account_type_name: a.account_type.name)
          .merge!(bills:
                    build_list(:bill, 1, account: nil).map!{|b|
                    b.attributes.except('id', 'created_at', 'updated_at', 'account_id')
                  })
      end
      let(:raw_post) { { account: account }.to_json }

      parameter :account_type_name, 'Type of account', scope: :account
      parameter :number, 'Account Number', scope: :account
      parameter :balance, 'Account Balance', scope: :account
      parameter :limit, 'Account Limit', scope: :account
      parameter :statement_date, 'Statement Date', scope: :account
      parameter :points, 'Points', scope: :account
      parameter :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account

      response_field :id, 'Account ID', scope: :account, 'Type' => 'Number'
      response_field :account_type_name, 'Type of account', scope: :account, 'Type' => 'String'
      response_field :number, 'Account Number', scope: :account, 'Type' => 'String'
      response_field :balance, 'Account Balance', scope: :account, 'Type' => 'Decimal'
      response_field :limit, 'Account Limit', scope: :account, 'Type' => 'String'
      response_field :statement_date, 'Statement Date', scope: :account, 'Type' => 'Date'
      response_field :points, 'Points', scope: :account, 'Type' => 'String'
      response_field :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :account, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :account, 'Type' => 'String'

      example_request 'create' do
        explanation 'Create a Account.'
        expect(status).to eq(201)
      end
    end

    put '/v0/users/:user_id/accounts/:id' do
      let(:user_id) { user.id }
      let(:id) { user.accounts.first.id }
      let(:account) do
        build(:account)
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
      end
      let(:raw_post) { { account: account }.to_json }

      parameter :account_type_name, 'Type of account', scope: :account
      parameter :number, 'Account Number', scope: :account
      parameter :balance, 'Account Balance', scope: :account
      parameter :limit, 'Account Limit', scope: :account
      parameter :statement_date, 'Statement Date', scope: :account
      parameter :points, 'Points', scope: :account
      parameter :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account

      response_field :id, 'Account ID', scope: :account, 'Type' => 'Number'
      response_field :account_type_name, 'Type of account', scope: :account, 'Type' => 'String'
      response_field :number, 'Account Number', scope: :account, 'Type' => 'String'
      response_field :balance, 'Account Balance', scope: :account, 'Type' => 'Decimal'
      response_field :limit, 'Account Limit', scope: :account, 'Type' => 'String'
      response_field :statement_date, 'Statement Date', scope: :account, 'Type' => 'Date'
      response_field :points, 'Points', scope: :account, 'Type' => 'String'
      response_field :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :account, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :account, 'Type' => 'String'

      example_request 'update' do
        expect(status).to eq(200)
      end
    end
  end
  resource 'Users::Accounts:Bills', type: :acceptance do
    let(:user) { users.first }
    let(:account) { user.accounts.first }
    let(:bill){ account.bills.first }
    get '/v0/users/:user_id/accounts/:account/bills' do
      parameter :page, 'Current page of results. Default: 1'
      parameter :limit, 'Results per page. Default: 20.'
      let(:user_id) { user.id }
      let(:page) { 1 }
      let(:limit) { 20 }
      example_request 'index' do
        expect(status).to eq(200)
        expect(json['bills'].length).to eq(account.bills.length)
      end
    end

    get '/v0/users/:user_id/accounts/:id' do
      let(:user_id) { user.id }
      let(:id) { user.accounts.first.id }
      example_request 'show' do
        expect(status).to eq(200)
      end
    end

    post '/v0/users/:user_id/accounts' do
      let(:user_id) { user.id }
      let(:account) do
        a = build(:account)
        a
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
          .merge!(account_type_name: a.account_type.name)
          .merge!(bills:
                    build_list(:bill, 1, account: nil).map!{|b|
                    b.attributes.except('id', 'created_at', 'updated_at', 'account_id')
                  })
      end
      let(:raw_post) { { account: account }.to_json }

      parameter :account_type_name, 'Type of account', scope: :account
      parameter :number, 'Account Number', scope: :account
      parameter :balance, 'Account Balance', scope: :account
      parameter :limit, 'Account Limit', scope: :account
      parameter :statement_date, 'Statement Date', scope: :account
      parameter :points, 'Points', scope: :account
      parameter :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account

      response_field :id, 'Account ID', scope: :account, 'Type' => 'Number'
      response_field :account_type_name, 'Type of account', scope: :account, 'Type' => 'String'
      response_field :number, 'Account Number', scope: :account, 'Type' => 'String'
      response_field :balance, 'Account Balance', scope: :account, 'Type' => 'Decimal'
      response_field :limit, 'Account Limit', scope: :account, 'Type' => 'String'
      response_field :statement_date, 'Statement Date', scope: :account, 'Type' => 'Date'
      response_field :points, 'Points', scope: :account, 'Type' => 'String'
      response_field :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :account, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :account, 'Type' => 'String'

      example_request 'create' do
        explanation 'Create a Account.'
        expect(status).to eq(201)
      end
    end

    put '/v0/users/:user_id/accounts/:id' do
      let(:user_id) { user.id }
      let(:id) { user.accounts.first.id }
      let(:account) do
        build(:account)
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
      end
      let(:raw_post) { { account: account }.to_json }

      parameter :account_type_name, 'Type of account', scope: :account
      parameter :number, 'Account Number', scope: :account
      parameter :balance, 'Account Balance', scope: :account
      parameter :limit, 'Account Limit', scope: :account
      parameter :statement_date, 'Statement Date', scope: :account
      parameter :points, 'Points', scope: :account
      parameter :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account

      response_field :id, 'Account ID', scope: :account, 'Type' => 'Number'
      response_field :account_type_name, 'Type of account', scope: :account, 'Type' => 'String'
      response_field :number, 'Account Number', scope: :account, 'Type' => 'String'
      response_field :balance, 'Account Balance', scope: :account, 'Type' => 'Decimal'
      response_field :limit, 'Account Limit', scope: :account, 'Type' => 'String'
      response_field :statement_date, 'Statement Date', scope: :account, 'Type' => 'Date'
      response_field :points, 'Points', scope: :account, 'Type' => 'String'
      response_field :point_earn_rate, '0.5', 'Point Earn Rate', scope: :account, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :account, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :account, 'Type' => 'String'

      example_request 'update' do
        expect(status).to eq(200)
      end
    end
  end

  resource 'Users::Addresses', type: :acceptance do
    post '/v0/users/:user_id/addresses' do
      parameter :address_line_1, 'Address Line 1', scope: :address
      parameter :address_line_2, 'Address Line 2', scope: :address
      parameter :city, 'City', scope: :address
      parameter :state, 'State', scope: :address
      parameter :zip, 'Zip', scope: :address
      parameter :country, 'Country', scope: :address

      response_field :id, 'Id', scope: :address, 'Type' => 'Number'
      response_field :address_line_1, 'Address Line 1', scope: :address, 'Type' => 'String'
      response_field :address_line_2, 'Address Line 2', scope: :address, 'Type' => 'String'
      response_field :city, 'City', scope: :address, 'Type' => 'String'
      response_field :state, 'State', scope: :address, 'Type' => 'String'
      response_field :zip, 'Zip', scope: :address, 'Type' => 'String'
      response_field :country, 'Country', scope: :address, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :address, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :address, 'Type' => 'String'

      let(:user_id) { user.id }
      let(:address) do
        build(:address)
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
      end
      let(:raw_post) { { address: address }.to_json }

      example_request 'create' do
        explanation 'Create a Address.'
        expect(status).to eq(201)
        client.get(URI.parse(response_headers['location']).path, {}, headers)
        expect(status).to eq(200)
      end
    end
    put '/v0/users/:user_id/addresses/:id' do
      let(:user_id) { user.id }
      let(:id) { user.addresses.first.id }
      let(:address) do
        build(:address)
          .attributes
          .except('id', 'created_at', 'updated_at', 'user_id')
      end
      let(:raw_post) { { address: address }.to_json }

      parameter :address_line_1, 'Address Line 1', scope: :address
      parameter :address_line_2, 'Address Line 2', scope: :address
      parameter :city, 'City', scope: :address
      parameter :state, 'State', scope: :address
      parameter :zip, 'Zip', scope: :address
      parameter :country, 'Country', scope: :address

      response_field :id, 'Id', scope: :address, 'Type' => 'Number'
      response_field :address_line_1, 'Address Line 1', scope: :address, 'Type' => 'String'
      response_field :address_line_2, 'Address Line 2', scope: :address, 'Type' => 'String'
      response_field :city, 'City', scope: :address, 'Type' => 'String'
      response_field :state, 'State', scope: :address, 'Type' => 'String'
      response_field :zip, 'Zip', scope: :address, 'Type' => 'String'
      response_field :country, 'Country', scope: :address, 'Type' => 'String'
      response_field :created_at, 'Created At', scope: :address, 'Type' => 'String'
      response_field :updated_at, 'Updated At', scope: :address, 'Type' => 'String'

      example_request 'update' do
        expect(status).to eq(200)
      end
    end
    get '/v0/users/:user_id/addresses' do
      parameter :page, 'Current page of results. Default: 1'
      parameter :limit, 'Results per page. Default: 20.'
      let(:user_id) { user.id }
      let(:page) { 1 }
      let(:limit) { 20 }
      example_request 'index' do
        expect(status).to eq(200)
        expect(json['addresses'].length).to eq(user.addresses.length)
      end
    end
    get '/v0/users/:user_id/addresses/:id' do
      let(:user_id) { user.id }
      let(:id) { user.addresses.first.id }
      example_request 'show' do
        expect(status).to eq(200)
      end
    end
  end
end
