@mofo

Feature:
  As a store administrator
  I can edit and update my store details

  Background:
    Given I am a Store administrator for "Cool Sunglasses"
    And I visit "http://storeengine.com/cool-sunglasses/admin"
    Then I should be able to click to edit the store details

  Scenario:
    When I am editing the store
    And I change the store name
    And I update the store
    And I should see a confirmation flash message with "Store details updated."
    And I should be able to find the new store name
    And I should not be able to find the old store name

  Scenario:
    When I am editing the store
    And I change the store URL id
    And I update the store
    Then I should be asked to confirm I want to change the URL id
    And I should be warned about breaking existing links
    And I should have the option to cancel or confirm my action
    
  Scenario:
    When I am being asked about confirming the change to a store URL id
    And I choose to cancel
    Then I should be viewing the edit store page
    And the previous store URL id should be shown

  @javascript
  Scenario:
    When I am being asked about confirming the change to a store URL id
    And I choose to confirm
    And I should see a confirmation flash message with "Store details updated."
    And I should see my store admin section
    And the new store URL id should be displayed