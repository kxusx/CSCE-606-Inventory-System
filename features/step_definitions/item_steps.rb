Given("I am on the new item page") do
  visit new_item_path
end

When("I select a bin") do
  select Bin.first.name, from: "Bin"
end

Then("I should see the uploaded item picture") do
  expect(page).to have_css("img")
end
