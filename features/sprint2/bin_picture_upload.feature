Feature: Add Picture to a Bin
  As a user
  I want to upload a picture when creating a bin
  So that I can associate an image with the bin

  Scenario: User successfully uploads a picture for a bin
    Given I am logged in as "test@example.com" with password "Password1!" on the new bin page
    When I fill in the bin field "Name" with "Storage Bin"
    And I fill in the bin field "Location" with "Warehouse A"
    And I fill in the bin field "Category name" with "Electronics"
    And I attach a bin picture "spec/fixtures/files/bin_picture.jpg" to "Bin picture"
    And I press the bin button "Create Bin"
    Then I should see the bin creation success message "Bin was successfully created"
    And I should see the uploaded bin picture
