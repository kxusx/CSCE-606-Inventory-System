FactoryBot.define do
  factory :item do
    name { "Item A" }
    description { "A test item" }
    value { 100 }
    association :bin  # Ensures each item belongs to a bin
  end
end
