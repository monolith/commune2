@mailer

Feature: Various mailer functionalities
  Email may be sent at various times for various reasons.
  This feature is to test each of these instances.

  Background:
    Given the following user records
      | login     | email                 |
      | monolith  | monolith@commune2.com |

  Scenario: Invitation email should be sent when invited
    Given I am logged in as "monolith" 
      And I am on new invitation page
    When I fill in "invitation_email" with "hellhorse@gmail.com"
      And I press "Invite"
      
    Then "hellhorse@gmail.com" should receive 1 email
    When "hellhorse@gmail.com" opens the email with subject "Invitation to join Commune2"
    Then I should see "monolith@commune2.com has sent you a message." in the email
      And I should see "http://www.commune2.com" in the email

  Scenario: Invitation email should be sent when resent by invitee to inactive user
    Given the following invitation records
      | email                | invitee  |
      | hellhorse@gmail.com  | monolith |

    Given no emails have been sent
      And I am logged in as "monolith"
    When I am on invitations page
    Then I should see "hellhorse@gmail.com"
      And I should see "Resend invitation to hellhorse@gmail.com" button
    When I press "Resend invitation to hellhorse@gmail.com"
    Then "hellhorse@gmail.com" should receive 1 email
    When "hellhorse@gmail.com" opens the email with subject "Invitation to join Commune2"
    Then I should see "monolith@commune2.com has sent you a message." in the email
      And I should see "http://www.commune2.com" in the email
      And invitation for "hellhorse@gmail.com" should have resend_requested equal to false

  Scenario: Activation email should be sent after registration, with activation link 
    Given the following invitation records
      | email                | invitee  |
      | hellhorse@gmail.com  | monolith |

    Given I am on the registration page
      And my email is "hellhorse@gmail.com"
    When I fill in "user_login" with "billbob"
      And I fill in "user_email" with "hellhorse@gmail.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I press "Register"
    Then I should see "Thank you for registering."
      And I should receive an email with "Please activate your new account" in subject
      # there was a bug at one point that resent the invitation email with the activation
      # this checks that this no longer happens
      # there should be only 1 invitation email (sent during the set up/ given in this scenario)
      And I should have 1 email with "Invitation" in subject

    # Activation
    When I open this email
    Then I should see "Please activate your new account" in the subject
      And I should see "Please visit this url to activate your account" in the email
    When I click the first link in the email
    Then I should see "Your account has been activated"


  Scenario: Activation confirmation should be sent after activation
    # this set up should actually result in all relevant set up emails
    Given the following user records
      | login   | email               |
      | billbob | hellhorse@gmail.com |
      
    Given my email is "hellhorse@gmail.com"
    Then I should receive an email with "Your account has been activated" in subject


  Scenario: Reset password should be resent when requested by user
    Given I am on the forgot password page
    When I fill in "email" with "monolith@commune2.com"
      And I press "Help!"
    Then I should see "A password reset link has been sent to your email address: monolith@commune2.com"

    Given my email is "monolith@commune2.com"
    Then I should receive an email with "Password reset help" in subject 
    When I open this email
      And I click the first link in the email
    Then I should see "Reset Your Password"
    
    # might as well check that the reset works..
    When I fill in "user_password" with "helloworld"
      And I fill in "user_password_confirmation" with "helloworld"
      And I press "Reset password" 
    Then I should see "Password changed"

    # check that this actual changed the password
    Given I am logged in as "monolith" with password "helloworld"
    Then I should see "logged"
    

    Scenario: I should be able to email other people
      Given the following additional user records
      | login    | email            |
      | bob      | bob@commune2.com |
      
      Given I am logged in as "monolith"
        And I am on "bob's" profile
      Then I should see "send message" within "show-action-menu"
      When I click on "send message"
      Then I should see "New Message"
      When I fill in "message_subject" with "Hi bob!"
        And I fill in "message_body" with "I am your friend"
        And I press "Send Message"
      Then I should see "Message sent"
        And "bob@commune2.com" should receive an email with "Hi bob!" in subject
      When he opens this email
      Then he should see "I am your friend" in this email
        And reply-to should have "monolith@commune2.com"
      
