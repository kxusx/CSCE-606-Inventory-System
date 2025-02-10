Feature: User Registration
  As a new user
  I want to register an account
  So that I can log in and use the system

  Scenario: Successful registration
    When I visit the registration page
    And I fill in "Email" with "new_user@example.com"
    And I fill in "Password" with "newpassword123"
    And I fill in "Password confirmation" with "newpassword123"
    And I press "Sign up"
    Then I should see "Welcome! You have signed up successfully"
