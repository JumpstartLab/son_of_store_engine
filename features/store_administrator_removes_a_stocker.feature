Feature:
  As a store administrator
  I can remove a stocker

Background:
  Given I am a Store administrator for "Cool Sunglasses"
  And there is stocker with email "bar@bar.com"
  And I visit "http://storeengine.com/cool-sunglasses/admin"

@javascript
Scenario: Removing a stocker
  When I click "remove" for the stocker "bar@bar.com"
  Then I am asked to confirm the removal

  When I confirm it
  Then I am viewing the admin page
  Then I should see a confirmation flash message with "Role has been removed."
  And "bar@bar.com" does not show as a stocker
  Then an email is sent to "bar@bar.com" to notify them they are no longer a stocker for "Cool Sunglasses"

@javascript
Scenario: Changing one's mind about removing a stocker
  When I click "remove" for the stocker "bar@bar.com"
  Then I am asked to confirm the removal

  When I cancel it
  Then I am viewing the admin page
  And "bar@bar.com" shows as a stocker