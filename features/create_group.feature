Feature: create new group
  As a registered user
  I want to create a unique group
  
  @login  
  Scenario: create group
    When I create a new group
    Then I enter a name, purpose, dues, and photo
    Then they should validate
