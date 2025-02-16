  Feature: NFC Chip Scanning for Bin Access
    As a user
    I want to update a bin
    So that I can modify its details
  
  Background:
    Given I am logged in as "user@example.com" with password "Password123!"

  Scenario: Updating the bins
    When I visit the edit page for "bin1"
    And I fill in the bin name with "Updated Bin"
    And I press "Update Bin"
    Then I should see "Bin was successfully updated"
    And I should see "Updated Bin" on the bins list