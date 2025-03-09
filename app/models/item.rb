class Item < ApplicationRecord
  belongs_to :user
  belongs_to :bin, optional: true
  belongs_to :location, optional: true
  has_many_attached :item_pictures, dependent: :destroy
  
  validates :name, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_no_bin_status

  before_destroy :prevent_deletion_and_unassign

  # Scope for searching items by name
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.downcase}%") if query.present?
  }

  def unassigned?
    bin_id.nil? && no_bin?
  end

  private

  def inherit_bin_location
    self.location_id = bin.location_id if bin.present?
  end

  def prevent_deletion_and_unassign
    if Thread.current[:deletion_context] == :from_locations
      return true
    end
    # Instead of allowing destruction, unassign from bin
    self.update(bin_id: nil, no_bin: true)
    # Add an error message that will be available in the flash
    errors.add(:base, "Item was unassigned instead of deleted")
    # Prevent the actual destruction
    throw :abort
  end

  def validate_no_bin_status
    if bin_id.nil? && !no_bin?
      errors.add(:no_bin, "must be true when item is not assigned to a bin")
    elsif bin_id.present? && no_bin?
      errors.add(:no_bin, "must be false when item is assigned to a bin")
    end
  end
end
