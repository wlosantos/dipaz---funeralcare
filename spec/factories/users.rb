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

    trait :admin do
      after :create do |user|
        user.add_role :admin
      end
    end

    trait :client do
      after :create do |user|
        user.add_role :client
      end
    end
  end
end
