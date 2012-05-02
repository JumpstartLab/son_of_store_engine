Feature:
  As a store administrator
  I should be able to remove another store administrator

  Background:
    Given I am a Store administrator for "Cool Sunglasses"
    And there is another admin with email "foo@bar.com"
    And I visit "http://storeengine.com/cool-sunglasses/admin"

  @javascript
  Scenario: Removing an admin
    When I click "remove" for the admin "foo@bar.com"
    Then I am asked to confirm the removal
    When I confirm it
    Then I am viewing the admin page
    Then I should see a confirmation flash message with "Role has been removed."
    And "foo@bar.com" does not show as an admin
    And "foo@bar.com" is sent an email notification

  @javascript
  Scenario: Changing one's mind about removing an admin
    When I click "remove" for the admin "foo@bar.com"
    Then I am asked to confirm the removal
    When I cancel it
    Then I am viewing the admin page
    And "foo@bar.com" shows as an admin