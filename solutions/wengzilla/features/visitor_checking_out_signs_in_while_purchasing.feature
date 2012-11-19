@mofos

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

  Scenario: I can navigate through the checkout process
    Given I have a StoreEngine account
    When I visit "http://storeengine.com/signin/"
    When I choose to sign in
    When I visit "http://storeengine.com/cool-sunglasses/"
    Then I can directly add a product to my cart
    Then I am taken to my cart
    Then I can checkout
    Then I am asked to enter my credit card information
    Then I am asked to enter my shipping information
    Then I am finished
