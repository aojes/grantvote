Feature: social news on homepage
  As a user with friends
  I want to be informed of their wins and new sessions
  
  @login
  Scenario: friend creates a new blitz grant
    Given I have a friend
    And my friend has a new blitz grant
    Then I should see an activity listing my friend's new blitz grant
    
  @login
  Scenario: friend wins a blitz grant
    Given I have a friend
    And my friend has a new blitz grant
    And my friend wins a blitz grant
    Then I should see an activitiy listing my friend's winning a blitz grant
    
  @login @group
  Scenario: friend joins a group
    Given I have a friend
    And my friend joins a group
    Then I should see a listing for my friend joining the group
