class Session < ApplicationRecord
  belongs_to :user
  scope :between_dates, ->(start_date, end_date) { where(login_time: start_date..end_date) }
end
