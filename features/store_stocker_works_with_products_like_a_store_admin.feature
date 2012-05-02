Feature:
  As a store stocker
  I can work with products like a store admin

  Background:
    Given I am a Stocker for the store "Cool Sunglasses"
    And there are products in stock for my store
    And I visit "http://storeengine.com/cool-sunglasses/stock/products"

  Scenario: Stocker views admin listing of products
    Then I should see the list of products for my store

  Scenario: Stocker adds a product
    When I click "New Product"
    Then I am able to add a new product like a store admin
    When I save the product
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product was successfully created."

  Scenario: Stocker edits a product
    When I click "edit" for an existing product
    Then I am able to change the details (name, description, price, photo URL) like a store admin
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product was successfully updated."

  Scenario: Stocker retires a product
    When I click "retire" for an existing product
    Then that product is retired, as in the original StoreEngine requirements
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product status changed."
