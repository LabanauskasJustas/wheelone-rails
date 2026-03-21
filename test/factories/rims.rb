FactoryBot.define do
  factory :rim do
    association :team
    name { "MyString" }
    photo { nil }
  end
end
