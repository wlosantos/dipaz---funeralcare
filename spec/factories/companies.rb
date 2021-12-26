FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { CNPJ.generate(true) }
    domain { 'w3ndesign.com' }
    status { 'blocked' }

    trait :active do
      status { 'active' }
    end

    trait :cnpj_invalid do
      cnpj { '111.111' }
    end
  end
end
