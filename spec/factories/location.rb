FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Test Location #{n}" }  # ✅ Creates unique location names
  end
end
