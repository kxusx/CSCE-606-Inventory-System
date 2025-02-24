Given("I am a logged-in user for items") do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  visit login_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "Password1!"
  click_button "Login"
end

When("I visit the new item page for items") do
  visit new_item_path
end


When('I fill in the item-specific field {string} with {string}') do |field, value|
  case field
  when "Name"
    fill_in "item_name", with: value
  when "Description"
    fill_in "item_description", with: value
  when "Created date"
    fill_in "item_created_date", with: value
  when "Value"
    fill_in "item_value", with: value
  else
    fill_in field, with: value
  end
end


When("I select a bin") do
  user = @user || User.first || User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  bin = Bin.first || Bin.create!(name: "Default Bin", user: user)

  fill_in "Bin", with: bin.id  # Use fill_in instead of select
end

When("I debug the page") do
  puts page.html  # Prints the full HTML content of the current page
end


When("I attach a file {string} to the item picture field") do |file_path|
  attach_file("item[item_picture]", Rails.root.join(file_path))  # Use the correct field name from HTML
end

When("I click the item button {string}") do |button|
  click_button(button)
end

Then(/^I should see the item success message "(.*)"$/) do |message|
  expect(page).to have_selector('.flash-message', text: message, visible: :visible)
end

Then("I should see the uploaded item picture") do
  expect(page).to have_css("img")