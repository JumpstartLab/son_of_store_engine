@wip
Feature:
  As a visitor
  When checking out
  I can purchase without signing up

  Background:
    Given I am a visitor to the store "Cool Sunglasses"
    And I have added items to my cart

  Scenario: Visitor checks out without signing up
    When I checkout
    Then I can sign up for an account
    And I can sign in to my existing account
    And I can provide my email, billing, shipping, and credit card info to purchase directly

    When I provide my info directly
    And I purchase my order
    Then Ibe shown a confirmation page with a unique, hashed URL that displays my order details
    And I receive an email with my order details and the unique URL for later viewing
