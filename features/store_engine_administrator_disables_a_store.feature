Feature: 
  As a StoreEngine admin
  I can disable a store

  Background:
    Given I am a StoreEngine administrator
    And a store "Cool Runnings" has been approved and is enabled
    And I visit "http://storeengine.com/admin/stores"
  
  Scenario:
    When I click "disable" for the store "Cool Runnings"
    Then I am viewing the admin list of stores
    And I see a disabled confirmation flash message
    And I can see an option to "enable" the store "Cool Runnings"
    When I visit "http://storeengine.com/cool-runnings"
    Then I should see a page informing me the site is currently down for maintenance