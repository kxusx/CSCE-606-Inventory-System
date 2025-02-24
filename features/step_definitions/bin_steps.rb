# Step for logging in before creating a bin
Given('I am logged in as {string} with password {string} on the new bin page') do |email, password|
  @user = User.create!(email: email, password: password, name: "Test User")

  visit login_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Login"

  visit new_bin_path
  expect(page).to have_content("New bin")  # Adjust if your page title is different
end

# Step for filling in bin fields
When('I fill in the bin field {string} with {string}') do |field, value|
  case field
  when "Name"
    fill_in "bin_name", with: value
  when "Location"
    fill_in "bin_location", with: value
  when "Category name"
    fill_in "bin_category_name", with: value
  else
    fill_in field, with: value
  end
end

# Step for attaching a picture
When('I attach a bin picture {string} to {string}') do |file_path, field|
  attach_file("bin[bin_picture]", Rails.root.join(file_path))
end

# Step for clicking buttons
When("I press the bin button {string}") do |button|
  click_button(button)
# Step for clicking buttons
When("I press the bin button {string}") do |button|
  click_button(button)
end

# Step for checking success message
# Modify the success message step for bin creation to make it unique
Then("I should see the bin creation success message {string}") do |message|
  expect(page).to have_content(message)
# Step for checking success message
# Modify the success message step for bin creation to make it unique
Then("I should see the bin creation success message {string}") do |message|
  expect(page).to have_content(message)
end

# Step for checking if the picture is uploaded
Then('I should see the uploaded bin picture') do
  expect(page).to have_css("img")  # Ensures an image is displayed
# Step for checking if the picture is uploaded
Then('I should see the uploaded bin picture') do
  expect(page).to have_css("img")  # Ensures an image is displayed
end
