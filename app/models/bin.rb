class Bin < ApplicationRecord
  belongs_to :user, counter_cache: true # counter cache for bin counts
  has_many :items # reference to items
  has_many_attached :bin_pictures, dependent: :destroy # bin with multiple pictures

  validates :name, presence: true
end
