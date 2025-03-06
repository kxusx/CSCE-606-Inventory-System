Feature: Search Bars on Dashboard
  As a user of the website,
  I want to have two separate search bars,
  So that I can quickly find my bins/categories and items.

  Background:
    Given I am a logged-in user on the dashboard
    And I have a valid location

  ### ✅ SEARCH BAR FOR BINS/CATEGORIES ###
  Scenario: Searching for a bin by name
    When I enter "Storage" in the bins search bar
    And I click the bins search button
    Then I should see bins matching "Storage"

  Scenario: Searching for a category
    When I enter "Electronics" in the bins search bar
    And I click the bins search button
    Then I should see categories matching "Electronics"

  Scenario: No results found for bins/categories
    When I enter "NonExistentBin" in the bins search bar
    And I click the bins search button
    Then I should see a message "No bins or categories found."

  ### ✅ SEARCH BAR FOR ITEMS ###
  Scenario: Searching for an item by name
    When I enter "Drill" in the items search bar
    And I click the items search button
    Then I should see items matching "Drill"

  Scenario: Searching for an item with filters
    When I enter "Hammer" in the items search bar
    And I select "Tools" from the items filter dropdown
    And I click the items search button
    Then I should see items matching "Hammer" under the "Tools" category

  Scenario: No results found for items
    When I enter "NonExistentItem" in the items search bar
    And I click the items search button
    Then I should see a message "No items found."

  ### ✅ GENERAL SCENARIOS ###
  Scenario: Clearing the search field resets results
    When I enter "Hammer" in the items search bar
    And I click the items search button
    Then I should see items matching "Hammer"
    When I clear the items search field
    Then the item search results should be reset

    When I enter "Storage" in the bins search bar
    And I click the bins search button
    Then I should see bins matching "Storage"
    When I clear the bins search field
    Then the bin search results should be reset

