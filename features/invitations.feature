@invitations

Feature: Sending invitations to join commune2
  Members of the community, should be be able to invite others to join.
  However, to maintain exclusivity and site performance, number of invitations should be limited.
  Only admin users should have the ability to invite unlimitted members.

  Background:
    Given the following user records
      | login     | admin |
      | monolith  | true  |
      | bob       | false |
  
  Scenario: Sending an invitation
    Given I am logged in as "bob"
      And I am on new invitation page
    When I fill in "invitation_email" with "hellhorse@gmail.com"
      And I press "Invite"
    Then I should see "Invitation has been sent to hellhorse@gmail.com"


  Scenario: Cannot invite people that are already invited
    Given the following invitation records
      | email                |
      | hellhorse@gmail.com  |

    Given I am logged in as "bob"
      And I am on new invitation page
    When I fill in "invitation_email" with "hellhorse@gmail.com"
      And I press "Invite"
    Then I should see "Invitation failed"
      And I should see "Email already exists on the invite list"
  
  
  Scenario: A normal user should be able to send 4 emails per 24 hours
    Given the following invitation records
      | invitee | created_at                   |
      | bob     | Wed Aug 10 03:33:13 UTC 2009 |
      | bob     |                              |
      | bob     |                              |
      | bob     |                              |

    Given I am logged in as "bob"
      And I am on new invitation page
    Then I should see "You currently have 1 available invitation"
    When I fill in "invitation_email" with "hellhorse@gmail.com"
      And I press "Invite"
    Then I should see "Invitation has been sent to hellhorse@gmail.com"
      And I should see "You currently have 0 available invitations"
      And I should not see "Invite" button
    

  Scenario: An admin user should be able to send unlimitted invites
    Given the following invitation records
      | invitee  | created_at                   |
      | monolith |                              |
      | monolith |                              |
      | monolith |                              |
      | monolith |                              |
      | monolith |                              |
      | monolith |                              |
      | monolith |                              |

    Given I am logged in as "monolith"
      And I am on new invitation page
    Then I should see "You currently have 1000 available invitations"
    When I fill in "invitation_email" with "hellhorse@gmail.com"
      And I press "Invite"
    Then I should see "Invitation has been sent to hellhorse@gmail.com"
      And I should see "You currently have 1000 available invitations"
      And I should see "Invite" button


  Scenario: I should see status of people I invited
    Given the following invitation records
      | email                 | invitee  |
      | hellhorse@gmail.com   | monolith |
      | hellhorse2@gmail.com  | monolith |
      | hellhorse3@gmail.com  | monolith |
      | hellhorse4@gmail.com  | bob      |
      | hellhorse5@gmail.com  | bob      |

    Given the following additional user records
      | login      | email                | active |
      | billbob    | hellhorse@gmail.com  | false  |
      | johnbob    | hellhorse2@gmail.com | true   |
      | annbob     | hellhorse3@gmail.com | true   |
      | bobcat     | hellhorse4@gmail.com | true   |
      | bigbob     | hellhorse5@gmail.com | false  |
          
    Given I am logged in as "monolith"
      And I am on invitations page
    Then I should see "Registered as johnbob"
      And I should see "Registered as annbob"
      And I should see "hellhorse@gmail.com"
      And I should see "hellhorse2@gmail.com"
      And I should see "hellhorse3@gmail.com"      
      But I should not see "Registered as billbob"
        And I should not see "hellhorse4@gmail.com"
        And I should not see "hellhorse5@gmail.com"
    When I follow "johnbob"
    Then I should be on "johnbob's" profile
    
    Given I am logged in as "bob"
      And I am on invitations page
    Then I should see "Registered as bobcat"
      And I should see "hellhorse4@gmail.com"
      And I should see "hellhorse5@gmail.com"
      But I should not see "Registered as bigbob"
        And I should not see "hellhorse@gmail.com"
        And I should not see "hellhorse2@gmail.com"
        And I should not see "Registered as johnbob"
    When I follow "bobcat"
    Then I should be on "bobcat's" profile

  Scenario: I should be able to resend invitation if the person has not registered yet
    Given the following invitation records
      | email                  | invitee  |
      | hellhorse@gmail.com    | monolith |
      | hellhorse2@gmail.com   | monolith |

    Given the following additional user records
      | login      | email                | active |
      | billbob    | hellhorse@gmail.com  | false  |
      | johnbob    | hellhorse2@gmail.com | true   |
      
    Given I am logged in as "monolith"
    When I am on invitations page
    Then I should see "hellhorse@gmail.com"
      And I should see "Resend invitation to hellhorse@gmail.com" button
      But I should not see "Resend invitation to hellhorse2@gmail.com" button
    When I press "Resend invitation to hellhorse@gmail.com"
    Then I should see "Invitation resent to hellhorse@gmail.com"

