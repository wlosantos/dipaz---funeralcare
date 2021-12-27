FactoryBot.define do
  factory :register do
    name { Faker::Name.name_with_middle }
    birthday { Faker::Date.between(from: '1960-09-23', to: '2020-09-25') }
    rg { '1502991' }
    cpf { CPF.generate(true) }
    accession_at { Faker::Date.between(from: '1960-09-23', to: '2020-09-25') }
    plan { 'titular' }
    status { 'active' }
    company

    trait :cpf_invalid do
      cpf { '111.111.111-11' }
    end
  end
end
