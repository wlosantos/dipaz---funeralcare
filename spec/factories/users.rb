FactoryBot.define do
  factory :user do
    name { Faker::Name.name_with_middle }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    password { '123456' }
    status { 'active' }
    company

    trait :inactive do
      status { 'inactive' }
    end

    trait :email_invalid do
      email { 'invalid@' }
    end
  end
end
