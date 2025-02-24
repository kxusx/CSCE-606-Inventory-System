
Feature: Create Items Without Bin Assignment
  As a user
  I want to create items without assigning them to bins
  So that I can catalog items before organizing them

  Background:
    Given I am a logged-in user

  Scenario: Creating an item without a bin
    When I visit the new item page
    And I fill in the item field "name" with "New Camera"
    And I fill in the item field "value" with "499.99"
    And I select "bin" from the bin dropdown
    And I click "Create Item"
    Then I should see "Item was successfully created"
    And I should see "New Camera" in the unassigned items list
    And the item "New Camera" should have no bin assigned

  Scenario: Validation errors when creating unassigned item
    When I visit the new item page
    And I select "No Bin" from the bin dropdown
    And I leave the "Name" field empty
    And I fill in "Value" with "-10.00"
    And I click "Create Item"
    Then I should see "Name can't be blank"
    And I should see "Value must be greater than or equal to 0"

  Scenario: Creating an item and assigning it to a bin later
    Given I have an unassigned item "Old Laptop"
    And I have a bin named "Electronics"
    When I visit the edit page for item "Old Laptop"
    And I select "Electronics" from the bin dropdown
    And I click "Update Item"
    Then I should see "Item was successfully updated"
    And I should see "Old Laptop" in the "Electronics" items list

  Scenario: Viewing unassigned items in a separate list
    Given I have the following unassigned items:
      | name          | description      | value  |
      | Old Phone     | Samsung S9       | 200.00 |
      | Headphones    | Sony WH-1000XM4  | 349.99 |
    When I visit the items page
    Then I should see an "Unassigned Items" section
    And I should see "Old Phone" in the unassigned items list
    And I should see "Headphones" in the unassigned items list

