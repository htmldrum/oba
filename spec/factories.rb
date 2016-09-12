FactoryGirl.define do

  factory :account do
    user
    card_type { Faker::Business.credit_card_type }
    number { Faker::Business.credit_card_number }
    cvv { "#{[rand(10),rand(10),rand(10)].join}" }
    balance { "#{rand(10).to_s*4}.#{rand(10).to_s*2}" }
    limit { "#{rand(10).to_s*4}.#{rand(10).to_s*2}" }
    statement_date{ Faker::Time.between(60.days.ago, DateTime.now).strftime('%Y-%m-%d') }
    points { "#{rand(10).to_s*2}" }
    point_earn_rate "0.5"
    trait :with_bill do
      after :build do |a|
        a.bills << create(:bill, account: a)
      end
    end
  end

  factory :address do
    user
    country { Faker::Address.country }
    address_name { "#{Faker::Name.first_name}'s #{rand(2) == 0 ? "country home" : "tiny apartment"}" }
    post_code{ Faker::Address.postcode }
    city { Faker::Address.city }
    state { Faker::Address.state }
    suburb { Faker::Address.city }
    street { "#{Faker:: Address.street_name} #{Faker::Address.street_suffix}" }
    street_number{ Faker::Address.building_number }
    unit_number { "##{rand(300)}" }
    company_name{ Faker::Company.name }
    delivery_instructions{
      ["Leave on the front steps",
       "Come around the side but watch out for the dog",
       "Don't leave it with the guy at the front desk, he steal my shit",
       "Under the awning is a safe place."].sample }
    po_box_number{ "P.O. box #{[rand(10), rand(10), rand(10), rand(10)].join}" }
  end

  factory :bill do
    account
    due_date { Date.today + 28.days }
    value { "#{rand(10)}.#{rand(10)}#{rand(10)}" }
  end

  factory :user do
    pin { "#{[rand(10),rand(10),rand(10),rand(10)].join}" }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone }
    title{ Faker::Name.prefix }
    suffix{ Faker::Name.suffix }
    dob{ Faker::Time.between(100.years.ago, 18.years.ago)}
    mobile_number{ Faker::PhoneNumber.cell_phone }
    fax_number{ Faker::PhoneNumber.cell_phone }
    gender{ rand(2) == 0 ? "Male" : "Female "}
    trait :with_account do
      after :build do |u|
        u.accounts << create(:account, :with_bill, user: u)
      end
    end
    trait :with_address do
      after :build do |u|
        u.addresses << create(:address, user: u)
      end
    end
    trait :valid do
      auth_token do |n|
        JWT.encode({ magical_mystery: "token #{n.object_id}" },
                   $HMAC_SECRET,
                   $HMAC_METHOD)
      end
    end
  end
end
