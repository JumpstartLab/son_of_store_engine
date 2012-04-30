@wip
Feature:
  As an admin
  I can view a list of all stores

  Scenario: StoreEngine administrator views list of stores
    Given I am a StoreEngine administrator
    And I visit "http://storeengine.com/admin/stores"
    Then I should see a listing of all stores in the system
    And each store should display its name, URL id, the first 32 characters of its   description, and links to administer, approve, decline, disable, or enable the store

#Details:

#* Approve and decline should only show if the store is pending, and then no other links should show.
#* Enable/disable are mutually exclusive links.
