Feature:
  As a store administrator
  I can add a new stocker

Background:
  Given I am a Store administrator for "Cool Sunglasses"
  And I visit "http://storeengine.com/cool-sunglasses/admin"
  And I to click to add a new stocker

Scenario: Adding stocker with a StoreEngine user account
  Given "bar@bar.com" has a StoreEngine user account
  When I add the stocker "bar@bar.com"
  Then an email is sent to "bar@bar.com" to notify them they are a stocker for "Cool Sunglasses" and can access the admin page at ""http://storeengine.com/cool-sunglasses/stock/products"

Scenario: Adding a stocker without a StoreEngine user account
  When I add the stocker "bar@bar.com"
  And "bar@bar.com" does not have a StoreEngine user account
  Then an email is sent to "bar@bar.com" inviting them to sign up for a StoreEngine account with a sign up link