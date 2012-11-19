Feature:
  As a StoreEngine admin
  I can enable a store

  Background:
    Given I am a StoreEngine administrator
    And a store "Cool Runnings" has been approved but is disabled
    And I visit "http://storeengine.com/admin/stores"
  
  Scenario: StoreEngine admin enables store
    When I click "enable" for the store "Cool Runnings"
    Then I am viewing the admin list of stores
    And I should see a confirmation flash message
    And I can see an option to "disable" the store "Cool Runnings"

    When I visit "http://storeengine.com/cool-runnings"
    Then I should see products for the store "Cool Runnings"