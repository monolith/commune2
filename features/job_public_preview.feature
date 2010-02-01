@job_public_preview

Feature: Access to jobs when not logged in
  In order to allow people to view open jobs without being logged in (e.g. coming from job board link)
  As a user who is not logged in
  I want to see the job and understand how to join commune2 and apply for the job

  Background:
    Given the following user records
      | login     | active |
      | monolith  | true   |
      | bob       | true   |

    Given the following job records
      | author    | project              | title                | active  | open  | external_publish_ok | description       |
      | bob       | Woah project         | Santas helper        | true    | true  |  true               | elf needed        |
      | monolith  | Monolithic project   | Director of testing  | true    | true  |  true               | experience please |
      | monolith  | Monolithic project   | Project Manager      | true    | false |  true               | boss              |
      | monolith  | Monolithic project   | Rails developer      | false   | true  |  true               | also merb         |
      | monolith  | Monolithic project   | Merb developer       | true    | true  |  false              | also merb         |


  Scenario Outline: Job is open and user is not logged in

    Given I am logged out
    When I go to view "<job title>" job through public preview
    Then I should see "<job title>"
      And I should see a link to "Log in"
      And I should see "<description>"
      And I should see "you need an invitation"
      And I should see "invitations at commune2 dot com"

    Examples:
    | job title           | description       |
    | Santas helper       | elf needed        |
    | Director of testing | experience please |


  Scenario Outline: Job is not open, inactive, or set to not publish

    Given I am logged out
    When I go to view "<job title>" job through public preview
    Then I should not see "<job title>"
      And I should see "Sorry, looks like the job you were looking for is not available"
      And I should be on the homepage

    Examples:
    | job title       |
    | Project Manager |
    | Rails developer |
    | Merb developer  |


  Scenario Outline: Logging in should take me to real job page

    Given I am logged out
    When I go to view "<job title>" job through public preview
      And I click on "Log in"
    Then I should be on redirected to login page
    When I fill in "login" with "monolith"
      And I fill in "password" with "secret"
      And I press "Log in"
    Then I should be on "<job title>" job page
      And I should see "Apply" button

    Examples:
      | job title           |
      | Santas helper       |
      | Director of testing |


  Scenario Outline: User is actually logged in

    Given I am logged in as "monolith"
    When I go to view "<job title>" job through public preview
    Then I should be on "<job title>" job page

    Examples:
    | job title           |
    | Santas helper       |
    | Director of testing |

  Scenario Outline: Indeed XML Feed, ensuring the right jobs are included
  # This checks content, not format

    Given I am on indeed job feed page
    Then the output should <action>

    Examples:
    | action            |
    | include "Santas helper"       |
    | include "Director of testing" |
    | not include "Project Manager" |
    | not include "Rails developer" |
    | not include "Merb developer"  |

