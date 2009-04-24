Feature: limit writing of grants against the solvency of the group
  In order to better maintain the solvency of a group
  Writing should be limited on various factors 
  
  @login @group @voter
  Scenario: voter can only have one session grant per group
    When I write a grant
    Then I vote the grant into session
    Then I write another grant
    And I am not allowed to vote it into session    
    
