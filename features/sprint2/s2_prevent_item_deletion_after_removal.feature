
Feature: Prevent Item Deletion After Bin Removal
  As a user
  I want items to remain in the system after removing them from bins
  So that I don't lose item data when reorganizing my inventory

  Background:
    Given I am logged in as "user@example.com" with password "Password123!"
    And I have a bin named "Kitchen Stuff"
    And I have an item "Coffee Maker" in the "Kitchen Stuff" bin

  Scenario: Removing an item from a bin
    When I visit the edit page for item "Coffee Maker"
    And I select "No Bin" from the bin dropdown
    And I click "Update Item"
    Then I should see "Item was successfully updated"
    And I should see "Coffee Maker" in the unassigned items list
    And the item "Coffee Maker" should have no bin assigned

  Scenario: Attempting to delete an item
    When I visit the items page
    And I click "Delete" for item "Coffee Maker"
    Then I should see "Item was unassigned instead of deleted"
    And I should see "Coffee Maker" in the unassigned items list
    And the item "Coffee Maker" should have no bin assigned

  Scenario: Reassigning an unassigned item to a new bin
    Given I have an unassigned item "Blender"
    And I have a bin named "New Kitchen Bin"
    When I visit the edit page for item "Blender"
    And I select "New Kitchen Bin" from the bin dropdown
    And I click "Update Item"
    Then I should see "Item was successfully updated"
    And I should see "Blender" in the "New Kitchen Bin" items list

