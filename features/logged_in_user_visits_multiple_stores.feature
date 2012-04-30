Feature:
  As a user
  I can visit multiple stores

Scenario: Logged in user visits multiple stores
  Given I am a logged in StoreEngine user
  And I visit "http://storeengine.com/cool-sunglasses"
  Then I am signed in
  And I visit "http://storeengine.com/cool-runnings"
  Then I am signed in