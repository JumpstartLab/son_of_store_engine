Feature:
  As a visitor
  I can add products to my acrt

  Background:
    Given I am a visitor to the store "Cool Sunglasses"

  Scenario: Visitor adds products to cart
    When I visit "http://storeengine.com/cool-sunglasses/"
    Then I can directly add a product to my cart
    Then I am taken to my cart
    Then I can update the quantity
    And I can remove the product from my cart

  Scenario: I can surf my products
    When I visit "http://storeengine.com/cool-sunglasses/"
    Then I can click on a product
    Then I am taken to the product