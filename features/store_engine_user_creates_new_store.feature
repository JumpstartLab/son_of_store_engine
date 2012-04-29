@wip
Feature:
  As a user
  I can create a new store

  Background:
    Given I am a logged in StoreEngine user
    And I visit "http://storeengine.com/profile"
    Then I should be able to click to create a new store

  Scenario: Creating with duplicate store name
    Given there is already a store called "Best Sunglasses"
    When I am creating a new store
    And I enter a store name, store URL identifier, and store description as "Best Sunglasses", "best-sunglasses", and "Buy our sunglasses!"
    And I create the store
    Then I should see an error about the duplicate name
    And I should be able to correct the error

  Scenario: Creating with duplicate URL id
    Given there is already a store with URL id "best-sunglasses"
    When I am creating a new store
    And I enter a store name, store URL identifier, and store description as "Best Sunglasses", "best-sunglasses", and "Buy our sunglasses!"
    And I create the store
    Then I should see an error about the duplicate URL id
    And I should be able to correct the error

  Scenario: Creating successfully with an admin
    When I am creating a new store
    And I enter a store name, store URL identifier, and store description as "Cool Sunglasses", "cool-sunglasses", and "Buy our cool sunglasses!"
    And I create the store
    Then I should see a confirmation of my store details
    And I should my new store is pending approval

    When I visit "http://storeengine.com/cool-sunglasses"
    Then I should see a not found error
