Feature:
  As a visitor
  When checking out
  I can sign up

  Background:
    Given I am a visitor to the store "Cool Sunglasses"
    And I have added items to my cart

  Scenario: Visitor signs up during checkout
    Given I don't have a StoreEngine account
    When I checkout
    Then I can sign up for an account
    And I can sign in to my existing account
    And I can continue to guest checkout where I can provide my email, billing, shipping, and credit card info to purchase directly
    
    When I choose to sign up
    Then I am asked for my account information

    When I create my account
    Then I should be logged in
    And I am returned to my checkout process
    And I can make my purchase normally
    And I should receive an email confirmation
