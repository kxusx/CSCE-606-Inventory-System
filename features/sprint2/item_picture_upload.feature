Feature: Add Picture to an Item
  As a user
  I want to upload a picture when creating an item
  So that I can associate an image with the item

  Scenario: User successfully uploads a picture for an item
    Given I am on the new item page
    When I fill in the item field "Name" with "Laptop"
    And I fill in the item field "Description" with "A high-performance laptop"
    And I fill in the item field "Created date" with "2025-02-24"
    And I fill in the item field "Value" with "1200"
    And I select a bin
    And I attach a file "spec/fixtures/files/item_picture.jpg" to "Item picture"
    And I press "Create Item"
    Then I should see "Item was successfully created"
    And I should see the uploaded item picture
