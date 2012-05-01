Feature:
  As a visitor
  I can create an account

  Background:
    Given I am not logged in
    And I am a visitor to the store "Cool Sunglasses"
    And I visit "http://storeengine.com/cool-sunglasses/cart"
    Given that my email address is "edweng@gmail.com"

  Scenario: Visitor signs up successfully
    Given I have not created a StoreEngine account with my email address before
    And I follow the sign up link
    Then I should be on a top-level page, "http://storeengine.com/signup"
    When I enter my email address, full name, and display name
    When I click the button or link to create my account
    Then I am returned to the page I was on
    And I should see a confirmation flash message with a link to change my account
    And I should receive an email confirmation

  Scenario: Visitor uses duplicate address
    Given I or someone else has created a StoreEngine account with my email address before
    And I follow the sign up link
    And I enter my email address, full name, and display name
    When I click the button or link to create my account
    Then I should see an error about duplicate email and a link to sign in
    And I should be able to correct it and resubmit

  Scenario: Visitor omits full name
    Given I have not created a StoreEngine account with my email address before 
    And I follow the sign up link
    And I enter my email address and display name
    When I click the button or link to create my account
    Then I should see an error telling me I need to specify a full name
    And I should be able to correct it and resubmit

  Scenario: Visitor omits display name
    Given I have not created a StoreEngine account with my email address before 
    And I follow the sign up link
    And I enter my email address and full name
    When I click the button or link to create my account
    Then I am returned to the page I was on
    And I should see a confirmation flash message with a link to change my account
    And I should receive an email confirmation