Given("I am on the new bin page") do
  visit new_bin_path
end

When("I fill in the bin field {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I attach a file {string} to {string}") do |file_path, field|
  attach_file(field, Rails.root.join(file_path))
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should see the uploaded bin picture") do
  expect(page).to have_css("img")
end
