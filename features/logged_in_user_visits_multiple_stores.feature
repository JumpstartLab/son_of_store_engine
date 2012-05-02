Feature:
  As a user
  I can visit multiple stores

  Background:
    Given I am a logged in StoreEngine user

  Scenario: Logged in user visits multiple stores
    And I visit "http://storeengine.com/cool-sunglasses"
    Then I am signed in
    And I visit "http://storeengine.com/cool-runnings"
    Then I am signed in