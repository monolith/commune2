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
      | joe      |

    Given the following project records
      | author    | title              | active |
      | bob       | Bobs project       | true   |
      | monolith  | Monolithic project | true   |
      | monolith  | Project not active | false  |

  Scenario Outline: Only project members can see post new project link

    Given the following job records
      | author    | project              | title                    |
      | bob       | Bobs project         | Santas helper            |
      | monolith  | Monolithic project   | Director of testing      |

    Given the following job application records
      | applicant | job                       | hired |
      | joe       | Director of testing       | true  |
      | joe       | Santas helper             | true  |
 
    Given I am logged in as "<user>"
    When I go to view "<title>" project
    Then I <action> "post job" within "show-action-menu"
    When I go to new job for "<title>" project
    Then I <action> "New Job"
    
    Examples:
    | user     | title              | action          |
    | monolith | Monolithic project | should see      |
    | joe      | Monolithic project | should see      |
    | bob      | Monolithic project | should not see  |
    


  Scenario Outline: Project members should be able to post jobs

    Given the following job records
      | author    | project              | title                    |
      | monolith  | Monolithic project   | Director of testing      |

    Given the following job application records
      | applicant | job                       | hired |
      | joe       | Director of testing       | true  |
 
    Given I am logged in as "<user>"
    When I go to view "Monolithic project" project
      And I click on "post job"
    Then I should see "New Job"
    When I fill in "job_title" with "cucumber tester"
      And I fill in "job_description" with "woohoo"
      And I check one of the general skills
      And I press "Create Job"
    Then I should see "This job has been posted"
    
    Examples:
    | user     |
    | monolith |
    | joe      |
    

  Scenario Outline: Job post for active and inactive project
    Given I am logged in as "monolith"
    When I go to view "<title>" project
      And I click on "post job"
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
