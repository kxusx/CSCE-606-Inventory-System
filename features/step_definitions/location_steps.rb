
Given("a location {string} exists") do |location_name|
  @location = Location.create!(name: location_name, user: @user)
end