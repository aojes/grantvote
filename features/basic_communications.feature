Feature: basic comms

  So that I can post updates for my friends to read
  As a registered user
  I want to post an update
  
  @login
  Scenario: post a basic update
    Given I am logged in
    When I enter some text
    Then I press Update
    Then I should see my comment on the page
    And I should see my avatar by the comment 
    And I should be able to delete the comment 

