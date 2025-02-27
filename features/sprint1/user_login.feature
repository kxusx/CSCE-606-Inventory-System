Feature: User Login
  As a user
  I want to be able to log in
  So that I can access the system

  Background:
    Given some user exists with email "rafaeldms27@icloud.com" and password "Abc1234!"

  Scenario: Successful login
    When I visit the login page
    And I fill in "Email" with "rafaeldms27@icloud.com"
    And I fill in "Password" with "Abc1234!"
    And I press "Login"
    Then I should see "Welcome, Rafael!"
