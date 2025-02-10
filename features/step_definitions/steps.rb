# features/step_definitions/steps.rb

Given('I am logged in as {string} with password {string}') do |email, password|
  visit '/login' # sessions#new
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in' # Ensure this matches the button in your form
end

Given('a user exists with email {string} and password {string}') do |email, password|
  User.create!(email: email, password: password, password_confirmation: password)
end

Given('a bin named {string} exists') do |bin_name|
  Bin.create!(name: bin_name)
end

When('I visit the new bin page') do
  visit new_bin_path # Correct route for new bin creation
end

When('I visit the new item page') do
  visit '/items/new' # Adjust if this path is different in your routes
end

When('I visit the registration page') do
  visit '/register' # Adjust this if your registration route is different
end

When('I visit the login page') do
  visit '/login' # sessions#new
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |option, dropdown|
  select option, from: dropdown
end

When('I press {string}') do |button|
  click_button button
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end
