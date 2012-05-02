Feature:
  As an admin
  I can decline a new store

  Background:
    Given I am a StoreEngine administrator
    And a store "Cool Runnings" has been created and is pending approval
    And I visit "http://storeengine.com/admin/stores"

  Scenario: StoreEngine admin declines a new store
    When I click "decline" for "Cool Runnings"
    Then I should see a confirmation flash message
    And I should not see the "Cool Runnings" in the list of stores
    And the user who requested approval is notified of the decline
