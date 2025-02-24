FactoryBot.define do
  factory :bin do
    sequence(:name) { |n| "Bin #{n}" }  # ✅ Ensure unique names
    sequence(:location) { |n| "Location #{n}" }
    sequence(:category_name) { |n| "Category #{n}" }
    association :user
  end
end