@job_applications

 Feature: Basic job application and hiring process
  In order to join a project or find help for my project
  As a user
  I want to be able to apply for jobs, review job applications, make an offer, and accept a job
  
  Background:
    Given the following user records
      | login     | active |
      | monolith  | true   |
      | bob       | true   |
      | joe       | true   |
      | notactive | false  |

    Given the following project records
      | author    | title              | active |
      | bob       | Woah project       | true   |
      | monolith  | Monolithic project | true   |
      | monolith  | Project not active | false  |


    Given the following job records
      | author    | project              | title                | active  | open  |
      | bob       | Woah project         | Santas helper        | true    | true  |
      | monolith  | Monolithic project   | Director of testing  | true    | true  |
      | monolith  | Monolithic project   | Project Manager      | true    | false |
      | monolith  | Monolithic project   | Rails developer      | false   | true  |
      | monolith  | Project not active   | Marketing guru       | true    | true  |


  Scenario Outline: See Job Status and Apply button
    Given I am logged in as "<user>"
    When I go to view "<job title>" job
    Then I should see "<status>" within "show-stat"
      And I <see> "Apply" button
        
    Examples:
      | user      | job title           | status           | see            |
      | bob       | Santas helper       | OPEN     | should see     |
      | bob       | Director of testing | OPEN     | should see     |
      | bob       | Project Manager     | filled   | should not see |
      | bob       | Marketing guru      | OPEN     | should see     |
      | monolith  | Rails developer     | INACTIVE | should see     |
      | notactive | Director of testing | OPEN     | should not see |


  Scenario: Only project members should see inactive jobs
  
    Given I am logged in as "monolith"
    When I go to view "Rails developer" job
    Then I should see "INACTIVE"
    Given I am logged in as "bob"
    When I go to view "Rails developer" job
    Then I should see "Sorry, no job to see here"

  
  Scenario Outline: Applying for job, making an offer, and accepting
    Given I am logged in as "bob"
    When I go to view "<job title>" job
      And I fill in "job_application_message" with "I am Bob, I apply!"
      And I press "Apply"
    Then I should see "You have applied for this job"
    When I am logged in as "<user>"
      And I go to view "<job title>" job
    Then I should see "bob"
      And I should see "Offer job to bob" button
    When I press "Offer job to bob"
    Then I should see "Offer made to bob"
      And I should see "offer made" within "show-stat"
      And I should see "Withdraw Offer" button
    Given I am logged in as "bob"
    When I go to view "<job title>" job
    Then I should see "Accept Job" button
      And I should see "This job has been offered to you"
    When I press "Accept Job"
    Then I should see "You are now hired for this position."
      And I should see "filled" within "show-stat"
      And I should see "Leave Job" button
    When I press "Leave Job"
    Then I should see "You have left this position"
      And I should see "offer made" within "show-stat"
    When I press "Accept Job"
    Then I should see "filled" within "show-stat"
    When I am logged in as "joe"
      And I go to view "<job title>" job
    Then I should see "bob"
      And I should see "filled" within "show-stat"
    When I am logged in as "<user>"
      And I go to view "<job title>" job
    Then I should see "filled" within "show-stat"
      And I should see "Applicant"
      And I should see "Remove From Position" button
    When I press "Remove From Position"
    Then I should see "offer made" within "show-stat"
    When I am logged in as "joe"
      And I go to view "<job title>" job
    Then I should not see "Applicant"
      And I should see "offer made" within "show-stat"
    When I am logged in as "<user>"
      And I go to view "<job title>" job
      And I press "Withdraw Offer"
    Then I should see "Offer withdrawn."
      And I should see "OPEN" within "show-stat"    

    Examples:
      | user      | job title           |
      | bob       | Santas helper        |
      | monolith  | Director of testing |
      | monolith  | Marketing guru      |
      

  Scenario: Multiple Applicants
    Given the following job application records
      | applicant | job                  |
      | bob       | Director of testing  |
      | joe       | Director of testing  |

    When I am logged in as "monolith"
      And I go to view "Director of testing" job
    Then I should see "bob"
      And I should see "Offer job to bob" button
      And I should see "joe"
      And I should see "Offer job to joe" button
    When I press "Offer job to joe"
    Then I should see "Offer made to joe"
      And I should see "offer made" within "show-stat"
      And I should see "Withdraw Offer" button
      And I should not see "Offer job to bob" button
    When I am logged in as "bob"
      And I go to view "Director of testing" job
    Then I should see "offer made" within "show-stat"
      And I should not see "joe"
      And I should not see "This job has been offered to you"
    When I am logged in as "joe"
      And I go to view "Director of testing" job
    Then I should see "This job has been offered to you"
    When I press "Accept Job"
    Then I should see "filled" within "show-stat"
      And I should see "Leave Job" button
    When I am logged in as "bob"
      And I go to view "Director of testing" job
    Then I should see "filled" within "show-stat"
      And I should see "joe"
    When I am logged in as "monolith"
      And I go to view "Director of testing" job
    Then I should not see "Offer job to bob" button
      And I should not see "Offer job to joe" button
      And I should see "Remove From Position" button
    When I press "Remove From Position"
    Then I should see "You have removed joe from this position"
      And I should see "Withdraw Offer" button
      And I should not see "Offer job to bob" button
      And I should see "offer made" within "show-stat"
    When I press "Withdraw Offer"
    Then I should see "OPEN" within "show-stat"
      And I should see "Offer job to bob" button
      And I should see "Offer job to joe" button
    When I am logged in as "bob"
      And I go to view "Director of testing" job
    Then I should not see "joe"
