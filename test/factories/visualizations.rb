FactoryBot.define do
  factory :visualization do
    association :team
    car { nil }
    rim { nil }
    status { "MyString" }
  end
end
