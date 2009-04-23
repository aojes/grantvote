Feature: public profile
  In order to better communicate my whole purpose
  As a registered user
  I want a public profile
  
  @login
  Scenario: create profile
    Given I am on my account page
    And I click the buttons to create and maintain a public profile
    When I have entered my full name
    And I have entered my text bio
    And I have entered a primary link
    And I have entered my location
    When I press Create
    Then I should be on the public profile page
    And I should see Profile create successfully
