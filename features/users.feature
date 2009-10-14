@users
 Feature: Basic user management
  As a user
  I want to be able to register, log in, log out, recover password, and invite
  So that I can use the website and invite others
    
    
  Scenario: Registration as first user OK without invite
    Given I am on the registration page
      And there are no users
      And there are no invitations
    When I fill in "user_login" with "first_user"
      And I fill in "user_email" with "first_user@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I press "Register"
    Then I should see "Thank you for registering."
    
    
  Scenario: Registration as invited user
    Given I am on the registration page
      And there are one or more users
      And there is an invitation for "invited_user@commune2.com"
    When I fill in "user_login" with "invited_user"
      And I fill in "user_email" with "invited_user@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I press "Register"
    Then I should see "Thank you for registering."
    
    
  Scenario: Registration should fail for uninvited user
    Given I am on the registration page
      And there are one or more users
      And there is no invitation for "not_invited@commune2.com"
    When I fill in "user_login" with "not_invited_user"
      And I fill in "user_email" with "not_invited@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I press "Register"
    Then I should see "Could not register"


  Scenario: Should not be able to login unless account is activated
    Given I am on the login page
      And I have an account with login "not_activated" and password "secret"
      And the account with login "not_activated" is not activated
    When I fill in "login" with "not_activated"
      And I fill in "password" with "secret"
      And I press "Log in"
    Then I should see "Log in failed"
      And I should see "Did you activate your account?"
    When I visit the activation link for "not_activated"
    Then I should see "Your account has been activated"
      And I should be on the login page
    When I fill in "login" with "not_activated"
      And I fill in "password" with "secret"
      And I press "Log in"
    Then I should see "logged in"
    
  Scenario Outline: Show or hide edit profile link
    Given the following user records
      | login    | password | admin |
      | bob      | secret   | false |
      | admin    | secret   | true  |

    Given I am logged in as "<login>" with password "secret"
    When I visit profile for "<profile>"
    Then I should <edit_action>
      And I should <delete_action>
    When I visit edit user page <profile>
    Then I should be on <page>
  
    Examples:
      | login | profile | edit_action     | delete_action         | page                     |
      | admin | bob     | not see "edit"  | see "delete user"     | "bob's" profile          |
      | bob   | bob     | see "edit"      | not see "delete user" | "bob's" edit page        |
      |       | bob     | see "Log On"    | not see "delete user" | redirected to login page |
      | bob   | admin   | not see "edit"  | not see "delete user" | "admin's" profile        |
      | admin | admin   | see "edit"      | see "delete user"     | "admin's" edit page      |


  Scenario: I should be able to edit my profile
    Given the following user records
      | login    | password |
      | monolith | secret   |

    Given I am logged in as "monolith" with password "secret"
    When I am on "monolith's" edit page
      And I fill in "user_headline" with "my new headline"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should see "Profile updated"
    When I am on "monolith's" profile
    Then I should see "my new headline" 

  # Location test requires internet connection    
  Scenario: More than one location found when registering
    Given I am on the registration page
      And there are one or more users
      And there is an invitation for "invited_user@commune2.com"
    When I fill in "user_login" with "invited_user"
      And I fill in "user_email" with "invited_user@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "Springfield"
      And I press "Register"
    Then I should not see "Thank you for registering."
      But I should see "Multiple locations found"
    When I choose "location_select_springfield_il_usa"
      And I press "Register"
    Then I should see "Thank you for registering."

  # Location test requires internet connection    
  Scenario: More than one location found when updating profile with a new location
    Given the following user records
      | login    | password |
      | monolith | secret   |

    Given I am logged in as "monolith" with password "secret"
    When I am on "monolith's" edit page
      And I fill in "new_location" with "Springfield"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should not see "Profile updated"
      But I should see "Multiple locations found"
    When I choose "location_select_springfield_il_usa"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should see "Profile updated"
    When I am on "monolith's" profile
    Then I should see "Springfield, IL, USA"


@focus

  Scenario: I should be able to change my user name, if another does not exist
    Given the following user records
      | login    | password |
      | monolith | secret   |
      | bob      | secret   |

    Given I am logged in as "monolith"
    When I click on "monolith"
    Then I should see "My Profile and Account"
    When I fill in "user_login" with "flapjack"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should see "Profile updated"
      And my login should be "flapjack"
    When I fill in "user_login" with "bob"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should see "Could not save changes"
      And I should see "Login has already been taken"
      And I should see "My Profile and Account"
      And my login should be "flapjack"
    When I fill in "user_login" with "monolith"
      And I fill in "password" with "secret"
      And I press "Save Changes & Update Profile"
    Then I should see "Profile updated"
      And my login should be "monolith"

