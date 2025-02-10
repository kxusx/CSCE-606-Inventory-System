Feature: User Login
  As a user
  I want to be able to log in
  So that I can access the system

  Background:
    Given a user exists with email "user@example.com" and password "password123"

  Scenario: Successful login
    When I visit the login page
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password123"
    And I press "Log in"
    Then I should see "Logged in successfully"
