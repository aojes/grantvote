Feature: watch existing group
  I want to watch a group without paying dues
  
  Scenario: watch group
    When I find an interesting group
    Then I join without paying dues
    Then I am a member without voting interest
