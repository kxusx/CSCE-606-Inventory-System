# Step to log in as a user
Given("I am a logged-in user for item creation") do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  visit new_user_session_path
  fill_in "user[email]", with: "test@example.com"
  fill_in "user[password]", with: "Password1!"
  click_button "Login"
end



# Step to visit the new item page
When("I visit the new item page to add a picture") do
  visit new_item_path
end

# Step to fill in item-specific fields for picture upload
When("I fill in the item-specific field {string} with {string}") do |field, value|
  case field
  when "Name"
    fill_in "item[name]", with: value
  when "Value"
    fill_in "item[value]", with: value
  else
    fill_in field, with: value
  end
end

# Step for selecting a bin from the dropdown
When('I select a bin') do
  select "Choose a bin", from: "item[bin_id]"  # Ensure the "Choose a bin" is an option in the dropdown
end

# Step to attach a file for item picture
When('I attach a file {string} to the item picture field') do |file_path|
  attach_file('item[item_pictures][]', Rails.root.join(file_path)) # Attach the file to the item_picture field
end

# Step to click the item button to create the item
When('I click the item button {string}') do |button|
  click_button(button)  # Click the Create Item button
end

# Step to verify item creation success message
Then('I should see the item success message {string}') do |message|
  expect(page).to have_content(message)  # Expect to see the success message after item creation
end

# Step to verify the uploaded item picture
Then('I should see the uploaded item picture') do
  expect(page).to have_css("img")  # Expect an image tag for the uploaded picture
end
