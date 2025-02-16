Given("I am a logged-in user") do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')
  visit login_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "Password1!"
  click_button "Login"
end

When("I visit the new bin page") do
  visit new_bin_path
end

When(/^I fill in "(.*)" with "(.*)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I select "(.*)" from "(.*)"$/) do |value, field|
  select value, from: field
end

When("I click {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should see a QR code") do
  expect(page).to have_css("svg") # ✅ Checks if an SVG exists in the page
end
