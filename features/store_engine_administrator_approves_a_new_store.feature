Feature:
  As an admin
  I can approve a new store

  Background:
    Given I am a StoreEngine administrator
    And a store "Cool Runnings" has been created and is pending approval
    And I visit "http://storeengine.com/admin/stores"

  Scenario: StoreEngine admin approves a new store
    When I click "approve" for "Cool Runnings"
    Then I should see a confirmation flash message
    And I should see the "Cool Runnings" in the list of stores
    And I should not see the option to "approve" or "decline" it
    And the user who requested approval is notified of the acceptance
