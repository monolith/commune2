@login_required

 Feature: Required logon for certain functionality
  In order for the site to maintain quality content
  As a user
  I want to be logged in before I can perform basic tasks

  Background:    
    Given the following user records
      | login     | password |
      | monolith  | secret   |
 
    
  Scenario Outline: Redirect to login page when trying to post when logged in
    Given I am logged out
    When I go to <item> page
    Then I should be on redirected to login page
    When I fill in "login" with "monolith"
      And I fill in "password" with "secret"
      And I press "Log in"
    Then I should see "<header>"
  
    Examples:
      | item        | header                                  |
      | new idea    | New Idea                                |
      | new project | To start a project                      |
      | new job     | To post a job                           |
      | ideas       | Ideas                                   |
      | projects    | Projects                                |
      | jobs        | Jobs                                    |
      | profiles    | People                                  |
      

  Scenario: I should not be required to be logged in in order to register
    Given I am logged out
    When I am on the registration page
    Then I should see "Registration"

