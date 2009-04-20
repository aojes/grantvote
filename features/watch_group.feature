Feature: watch existing group
  As a registered, logged in user
  I want to join a group without paying dues
  
  @login @group
  Scenario: watch group
    When I join a group without paying dues
    Then I am a member without voting interest
