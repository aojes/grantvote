Feature: create new group
  As a registered user
  I want to create a unique group
  
  Scenario: create group
    Given I am logged in
    When I create a new group
    Then I enter a name, purpose, dues, and photo
    And they must validate
