# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing records (optional, only if you want to delete everything before seeding)
Item.delete_all
Bin.delete_all

# Find or create the user
user = User.find_or_create_by!(name: "Rafael", email: "rafaeldms27@icloud.com") do |u|
  u.password = "Robert123!"  # Set a password
end

# Create a Bin
bin = user.bins.create!(
  name: "Electronics",
  location: "Warehouse",
  category_name: "Tech"
)

# Create a first Item in the Bin
bin.items.create!(
  name: "Alexa",
  description: "Alexa Echo",
  created_date: Time.now,
  value: 100.0
)


# Create a second Item in the Bin
bin.items.create!(
  name: "stapple",
  description: "Stapple old",
  created_date: Time.now,
  value: 20.0
)