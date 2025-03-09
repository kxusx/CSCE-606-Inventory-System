class Location < ApplicationRecord
  belongs_to :user
  has_many :bins, dependent: :destroy
  has_many :items, dependent: :destroy
  validates :name, presence: true
end
