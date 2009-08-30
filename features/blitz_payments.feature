Feature: Blitz payments
  So that I can vote and write blitz grants
  As a user
  I want my payment to reflect on my account successfully

  @login
  Scenario Outline: blitz payments
    Given my blitz interest is <interest>
    And my blitz contributions equal <contributes>
    And my blitz rewards equal <rewards>
    When I make a payment of <payment>
    Then I should have a blitz interest of <blitz_interest>
    And I should have a new total blitz contribution of <new_total>

  Scenarios: successful payments
    | interest | contributes | rewards | payment | blitz_interest | new_total |
    | false    | 0           | 0       | 4.85    | true           | 4         |

