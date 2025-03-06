Given('I am a logged-in user on the dashboard') do
  @user = User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!')

  visit new_user_session_path
  fill_in "user[email]", with: "test@example.com"
  fill_in "user[password]", with: "Password1!"
  click_button "Login"

  expect(page).to have_current_path(dashboard_path) # Ensure login redirects correctly
end

When('I enter {string} in the bins search bar') do |search_term|
  fill_in 'search-inventory', with: search_term
end

And('I click the bins search button') do
  click_button 'search-inventory-btn'
end

Then('I should see bins matching {string}') do |search_term|
  within('.search-results') do  # Adjust selector based on actual results container
    expect(page).to have_content(search_term)
  end
end
