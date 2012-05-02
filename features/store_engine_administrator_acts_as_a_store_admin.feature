@mofos

Feature:
  As a StoreEngine admin
  I can act as a store admin

Scenario: StoreEngine admin acts as store admin
  Given I am a StoreEngine administrator
  And I visit "http://storeengine.com/admin/stores"
  When I click "administer" for the store "Cool Sunglasses"
  Then I am viewing the admin section for "Cool Runnings"
  And I can take any action an admin for "Cool Runnings" could take
