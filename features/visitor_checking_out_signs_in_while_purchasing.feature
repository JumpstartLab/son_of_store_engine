Feature:
  As a visitor
  When checking out
  I can sign in

  Background:
    Given I am a visitor to the store "Cool Sunglasses"
    And I have added items to my cart

  Scenario: Visitor signs in during checkout
    Given I have a StoreEngine account
    When I checkout
    Then I can sign up for an account
    And I can sign in to my existing account
    And I can continue to guest checkout where I can provide my email, billing, shipping, and credit card info to purchase directly

    When I choose to sign in
    Then I should be logged in
    And I am returned to my checkout process
    And I can make my purchase normally
