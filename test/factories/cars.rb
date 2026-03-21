FactoryBot.define do
  factory :car do
    association :team
    name { "MyString" }
    photo { nil }
  end
end
