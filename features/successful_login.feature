Scenario: successful login
  Given I am the registered user foo
  And I am on the homepage
  When I login with valid credentials
  Then I should be on the account page
  And I should see "Login successful!"
