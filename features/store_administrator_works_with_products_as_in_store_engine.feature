Feature:
  As a store administrator
  I should be able to work with products as in StoreEngine

  Background:
    Given I am a Store administrator for "Cool Sunglasses"
    And there are products in stock for my store
    And I visit "http://storeengine.com/cool-sunglasses/admin/products"

  Scenario: Admin views admin listing of products
    Then I should see the list of products for my store
    
  Scenario: Admin adds a product
    When I click "New Product"
    Then I am able to add a new product like I could in StoreEngine v1
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product was successfully created."

  Scenario: Admin edits a product
    When I click "edit" for an existing product
    Then I am able to change the details (name, description, price, photo URL) like I could in StoreEngine v1
    When I save my changes
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product was successfully updated."

  Scenario: Admin retires a product
    When I click "retire" for an existing product
    Then that product is retired, as in StoreEngine v1
    Then I should see the list of products for my store
    And I should see a confirmation flash message with "Product status changed."