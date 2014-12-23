FactoryGirl.define do
  factory :user do
    dob {Faker::Date.between(20.years.ago, 19.years.ago).strftime("%Y-%m-%d")}
    username {Faker::Internet.user_name}
    email {Faker::Internet.free_email}
    firstname {Faker::Name.first_name}
    lastname {Faker::Name.last_name}
    school {Faker::Company.name}
    patron_status "3"
    user_attributes({})
    address({
        street_address: Faker::Address.street_address,
        city:           Faker::Address.city,
        state:          Faker::Address.state,
        postalcode:     Faker::Address.zip_code
      })

    factory :admin do
      admin true
    end

    factory :valid_patron do
      patron_status "54"
    end

    factory :override_access do
      override_access true
    end
  end
end
