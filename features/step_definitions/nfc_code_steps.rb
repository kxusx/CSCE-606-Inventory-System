Given('I have a bin named {string} with an NFC link') do |bin_name|
  @bin = Bin.create!(name: bin_name, user: @user, location: "Garage", category_name: "Misc")
end

When('I scan the NFC chip for {string}') do |bin_name|
  bin = Bin.find_by(name: bin_name)
  visit bin_path(bin) # Simulate the redirection after scanning NFC
end

When('I scan an invalid NFC chip') do
  visit '/invalid_nfc'
end

Then('for NFC, I should be redirected to the bin page for {string}') do |bin_name|
  bin = Bin.find_by(name: bin_name)
  expect(page).to have_current_path(bin_path(bin))
  puts "Redirected to the correct bin page - PASSED"
end

Given('I am not logged in') do
  visit logout_path if page.has_link?('Logout') # Log out if already logged in
end


Given('I have a NFC bin named {string} with an NFC link') do |bin_name|
  @user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")
  @bin = @user.bins.create!(name: bin_name, location: "Garage", category_name: "Misc")

  # Simulate NFC link generation (same logic as in the app)
  @nfc_url = bin_path(@bin)
end

When('I also scan the NFC chip for {string}') do |bin_name|
  visit @nfc_url #use nfc url from top step
end


Then('I should be redirected to the login page') do
  expected_login_path = Rails.application.routes.url_helpers.login_path # Correct path for login
  expect(current_path).to eq(expected_login_path) # Check if user was redirected to login
end


When('I log in as {string}') do |email|
  fill_in "Email", with: email
  fill_in "Password", with: "Password1!"
  click_button "Login" # This should trigger `get_stored_location` and redirect
end

And('after logging in, I should be redirected to the bin page for {string}') do |_bin_name|
  expect(current_url).to eq(@nfc_url) # Ensure the redirection is correct
end


Given('I found a NFC bin named {string} with an NFC link') do |bin_name|
  @user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")
  @bin = @user.bins.create!(name: bin_name, location: "Garage", category_name: "Misc")

  # Simulate NFC link generation (same logic as in the app)
  @nfc_url = bin_path(@bin)
end

And('I should be redirected to the page {string}') do |expected_page|
  expected_url = Rails.application.routes.url_helpers.dashboard_path
  expect(current_path).to eq(expected_url) # Ensure the redirection is correct
end

When('I log in creating new user as {string}') do |email|
  @user = User.create!(name: "Test User", email: email, password: "Password1!")
  visit login_path
  fill_in "Email", with: email
  fill_in "Password", with: "Password1!"
  click_button "Login" # This should trigger `get_stored_location` and redirect
end