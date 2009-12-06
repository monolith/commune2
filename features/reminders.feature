# /features/reminders.feature
@reminders

  Feature: Reminders
    In order to get people to comeback to the site
    As a commune2 creator
    I want to ensure that relevant email reminders are automatically sent to users
 
    Scenario: User should be able to turn dashboard reminder on and off
      Given the following user records
        | login    |
        | monolith |

      Given the following reminder records
        | login    | dashboard |
        | monolith | true      |
    
      Given I am logged in as "monolith"
      When I am on "monolith's" edit page
      Then I should see "My Profile and Account"
        And the "Do you want this alert?" checkbox should be checked
      When I uncheck "Do you want this alert?"
        And I fill in "password" with "secret"
        And I press "Save Changes & Update Profile"
      Then I should see "Profile updated"
        And the "Do you want this alert?" checkbox should not be checked
        And "monolith's" dashboard reminder should be off
      When I check "Do you want this alert?"
        And I fill in "password" with "secret"
        And I press "Save Changes & Update Profile"
      Then I should see "Profile updated"
        And the "Do you want this alert?" checkbox should be checked
        And "monolith's" dashboard reminder should be on

    Scenario Outline: User should be on reminder list when the dashboard has some items, 
                      and user has not logged on for some time

      Given the following user records
        | login    | email                  |
        | monolith | monolith@commune2.com  |
        | bob      | bob@commune2.com       |
        | joe      | joe@commune2.com       |
        | jane     | jane@commune2.com      | 

      Given the following reminder records
        | login    | dashboard | dashboard_last_sent_at       | previous_logon               |
        | monolith | true      | Wed Aug 10 03:33:13 UTC 2009 | Wed Aug 10 03:33:13 UTC 2009 |
        | bob      | true      | Wed Aug 10 03:33:13 UTC 2009 | Wed Aug 10 03:33:13 UTC 2009 |
        | joe      | true      | Now                          | Wed Aug 10 03:33:13 UTC 2009 |
        | jane     | false     | Wed Aug 10 03:33:13 UTC 2009 | Wed Aug 10 03:33:13 UTC 2009 |

      Given the following idea records
        | author    | title           |
        | monolith  | Monoliths idea  |
        | bob       | Bobs idea       |
        | joe       | Joes idea       |
        | jane      | Janes idea      |
        
      # this is not meant to test the dashboard here, so simple comments will do
      Given the following comment records
        | commentator | comment on            | created_at                   |
        | monolith    | idea "Bobs idea"      | Wed Aug 17 03:33:13 UTC 2009 |
        | joe         | idea "Bobs idea"      | Wed Aug 17 03:33:13 UTC 2009 |
        | bob         | idea "Monoliths idea" | Wed Aug 17 03:33:13 UTC 2009 |
        | bob         | idea "Joes idea"      | Wed Aug 17 03:33:13 UTC 2009 |
        | monolith    | idea "Joes idea"     | Wed Aug 17 03:33:13 UTC 2009 | 
        | monolith    | idea "Janes idea"     | Wed Aug 17 03:33:13 UTC 2009 | 


      Given all users are activated
        And no emails have been sent
      Then <user> should have total of <count> items on dashboard
        And <user> <action> be on the reminder list
      When reminders are sent
      Then "<email>" <action> receive an email with "Dashboard" in subject
        And there should be no more users with pending reminders
      
      # joe shold not be on a list since dashboard was recently sent
      # jane does not want to get reminders
      Examples:
        | user      | count | action      | email                   |
        | monolith  | 1     | should      | monolith@commune2.com   |
        | bob       | 2     | should      | bob@commune2.com        |
        | joe       | 2     | should not  | joe@commune2.com        |
        | jane      | 1     | should not  | jane@commune2.com       | 

