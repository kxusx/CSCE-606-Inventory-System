Feature: QR Code Generation for Bins
  As a user
  I want to create a bin
  So that it generates a QR code automatically

  Scenario: User creates a bin and sees the QR code
    Given I am a logged-in user
    When I visit the new bin page
    And I fill in "Name" with "Storage Bin"
    And I fill in "Location" with "Garage"
    And I select "Misc" from "Category Name"
    And I click "Create Bin"
    Then I should see "Bin was successfully created"
    And I should see a QR code
