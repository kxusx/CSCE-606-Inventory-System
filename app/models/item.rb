class Item < ApplicationRecord
  belongs_to :bin
  has_one_attached :item_picture  # Ensure this is present!

  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
