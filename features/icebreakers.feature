# /features/icebreakers.feature
@icebreakers

  Feature: Icebreakers
    In order to stimulate some ideas during registration
    As a user
    I want to see some icebreakers during registration

  Scenario: Icebreakers should be shown on the registration page  

    Given the following icebreaker records
      | question      | approved |
      | Icebreaker 1  | true     |
      | Icebreaker 2  | true     |
      | Icebreaker 3  | true     |
      | Icebreaker 4  | false    |
      | Icebreaker 5  | true     |

    Given I am logged out
    When I go to the registration page
    Then I should see "Icebreaker"
    
  Scenario Outline: Only admin users should be able to visit the icebreaker index page
    Given the following user records
      | login    | admin  |
      | monolith | true   |
      | bob      | false  |
    
    Given I am logged in as "<person>"
    When I go to the icebreakers page
    Then I should <action> "Icebreakers"
      And I should be on the <page>
    
    Examples:
      | person    | action  | page             |
      | monolith  | see     | icebreakers page |
      | bob       | not see | homepage         |


  Scenario Outline: Only admins should be able to add Icebreakers
    Given the following user records
      | login    | admin  |
      | monolith | true   |
      | bob      | false  |
    
    Given I am logged in as "<person>"
      And there are no icebreakers
    When I try to create a new icebreaker
    Then there should be <number> of icebreakers

    Examples:
      | person    | number  |
      | monolith  | 1       |
      | bob       | 0       |

