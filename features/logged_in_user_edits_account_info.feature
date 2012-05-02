Feature:
  As a user
  I can edit my user details

  Background:
    Given I am a logged in StoreEngine user
    And I am on a StoreEngine store page
    Then I should see a link in the header for my account
  
  Scenario:
    When I click the my account link
    Then I am viewing my user profile and I see a link to edit my user details

    When I click the edit user details link
    Then I am viewing an edit form where I can change my full name, display name, and or password. The password change requires entering a password confirmation as well.