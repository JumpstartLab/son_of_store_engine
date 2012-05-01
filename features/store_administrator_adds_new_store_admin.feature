@mofo 

Feature:
  As a store administrator
  I should be able to add another store administrator

  Background:
    Given I am a Store administrator for "Cool Sunglasses"
    And I visit "http://storeengine.com/cool-sunglasses/admin"
    And I to click to add a new store admin

  Scenario: Adding an admin with a StoreEngine user account
    Given "foo@bar.com" has a StoreEngine user account
    When I add the admin "foo@bar.com"
    Then an email is sent to "foo@bar.com" to notify them they are an admin for "Cool Sunglasses" and can access the admin page at ""http://storeengine.com/cool-sunglasses/admin"

  Scenario: Adding an admin without a StoreEngine user account
    When I add the admin "foo@bar.com"
    And "foo@bar.com" does not have a StoreEngine user account
    Then an email is sent to "foo@bar.com" inviting them to sign up for a StoreEngine account with a sign up link