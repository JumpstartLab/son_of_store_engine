Feature:
  As a visitor
  I can visit a store at its unique url

  Background:
    Given there is a store named "Speedy Bikes" with URL id "speedy-bikes"
    And the store has a product named "Schwinn 10 Speed"
    And the store does not have a product "Hello Kitty Lunchbox"

  Scenario:
    When I visit "http://storeengine.com/speedy-bikes"
    And I browse its products
    Then I should see the product "Schwinn 10 Speed"

    When I visit "http://storeengine.com/speedy-bikes"
    And I browse its products
    Then I should not see the product "Hello Kitty Lunchbox"