@jobs

Feature: Basic job management
  In order to find help for my projects, or help others
  As a user
  I want to be able to post, update, view, apply for jobs

  Background:
    Given the following user records
      | login    |
      | monolith |
      | bob      |

    Given the following project records
      | author    | title              | active |
      | bob       | Bobs project       | true   |
      | monolith  | Monolithic project | true   |
      | monolith  | Project not active | false  |


  Scenario Outline: Only project members can post project jobs
    Given I am logged in as "<user>"
    When I go to view "<title>" project
    Then I <action> "Post a Job" button
    When I go to new job for "<title>" project
    Then I <action> "New Job"
    
    Examples:
    | user     | title              | action          |
    | monolith | Bobs project       | should not see  |
    | monolith | Monolithic project | should see      |
    | monolith | Project not active | should see      |
    |          | Monolithic project | should not see  |
    
    
  Scenario Outline: Job post for active and inactive project
    Given I am logged in as "monolith"
    When I go to view "<title>" project
      And I press "Post a Job"
    Then I should see "New Job"
    When I fill in "job_title" with "cucumber tester"
      And I fill in "job_description" with "woohoo"
      And I check one of the general skills
      And I press "Create Job"
    Then I should see "This job has been posted"
    When I go to jobs page
    Then I should see "cucumber tester"

    Examples:
    | title               |
    | Monolithic project  |
    | Project not active  |


  Scenario Outline: I should see active jobs only on the jobs page
    Given the following job records
      | author    | project              | title                | active  | open  |
      | monolith  | Paper jam fixer      | Technician           | true    | true  |
      | monolith  | Monolithic project   | Rails developer      | false   | true  |
      | monolith  | Project not active   | Marketing guru       | true    | false |

    When I am logged in as "<user>"
      And I am on the jobs page
    Then I should see "Technician"
      And I should not see "Rails developer"
      And I should not see "Marketing guru"

    Examples:
      | user     |
      | bob      |
      | monolith |


  Scenario Outline: Updating a job
    Given the following job records
      | author    | project              | title                | active  | open  |
      | monolith  | Paper jam fixer      | Technician           | true    | true  |
      | monolith  | Monolithic project   | Rails developer      | false   | true  |
      | monolith  | Project not active   | Marketing guru       | true    | false |
    
    When I am logged in as "monolith"
      And I go to edit "<title>" job
      And I fill in "job_title" with "New job title"
      And I fill in "job_description" with "hello world"
      And I press "Update"
    Then I should see "Changes saved"
    When I go to view "New job title" job
    Then I should see "hello world"

    Examples:
      | title           |
      | Technician      |
      | Rails developer |
      | Marketing guru  |
