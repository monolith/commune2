@job_application_notifications
Feature: Job application notification

In order to know when someone has applied for my job post
As a job poster
I want to receive an email whenever a new applicant applies for one of my jobs


Background:

    Given the following user records
      | login     | email                 | first_name  | last_name |
      | monolith  | monolith@commune2.com | jones       | smithey   |
      | bob       | bob@commune2.com      | robert      | smokes    |
      | joe       | joe@commune2.com      | willie      | millie    |

    Given the following project records
      | author    | title         |
      | monolith  | Monolithic    |
      | monolith  | Another       |
      | bob       | Some other    |


    Given the following job records
      | author    | project      | title                | active  | open  |
      | monolith  | Monolithic   | Director of testing  | true    | true  |
      | monolith  | Monolithic   | Rails developer      | true    | true  |
      | monolith  | Another      | Java developer       | true    | true  |
      | monolith  | Monolithic   | Not open             | true    | false |
      | monolith  | Monolithic   | Not active           | false   | true  |
      | bob       | Some other   | Sandwich maker       | true    | true  |



Scenario: Send email notification when new applicant applies for a job
  Given I am logged in as "monolith"
    And no emails have been sent
  When "bob" applies for "Director of testing" job
  Then I should receive an email with "New applicant for Director of testing" in subject
  When I open this email
  Then I should see "you have a new applicant for Director of testing" in the email
    And I should see "Monolithic project" in the email
  When I click the first link in the email
  Then I should be on "Director of testing" job page
  When "joe" applies for "Director of testing" job
    And "bob" applies for "Rails developer" job
    And "joe" applies for "Java developer" job
  Then I should have 4 emails
  When "joe" applies for "Sandwich maker" job
  Then "bob@commune2.com" should have 1 email


Scenario: Do not send notification if job is not open or inactive
  Given I am logged in as "monolith"
    And no emails have been sent
  When "bob" applies for "Not open" job
    And "joe" applies for "Not active" job
  Then I should have 0 emails


Scenario: Do not send notification if applicants is also the poster
  Given I am logged in as "monolith"
    And no emails have been sent
  When "monolith" applies for "Director of testing" job
  Then I should have 0 emails


Scenario: Notification should be sent to applicant when offer is made
  Given the following job application records
    | applicant | job                  |
    | bob       | Director of testing  |
    | joe       | Director of testing  |

  Given I am logged in as "monolith"
    And no emails have been sent
  When I offer the "Director of testing" job to "joe"
  Then "joe@commune2.com" should receive an email with "Job Offer" in subject
    But "bob@commune2.com" should have 0 emails
    And I should have 0 emails
  When I open the email sent to "joe@commune2.com" with "Job Offer" in subject
  Then I should see "you received an offer for the Director of testing job" in the email
    And I should see "Monolithic project" in the email
  When I click the first link in the email
  Then I should be on "Director of testing" job page


Scenario: Notification should be sent when applicant accepts offer
  Given the following job application records
    | applicant | job                  |
    | bob       | Director of testing  |
    | joe       | Director of testing  |

  Given I am logged in as "monolith"
    And no emails have been sent
  When "joe" accepts offer the "Director of testing" job
   Then I should receive an email with "Job Offer Accepted" in subject
    But "bob@commune2.com" should have 0 emails
    And "joe@commune2.com" should have 0 emails
  When I open the email with "Job Offer Accepted" in subject
  Then I should see "Willie Millie has accepted your offer for the Director of testing job" in the email
    And I should see "Monolithic project" in the email
  When I click the first link in the email
  Then I should be on "Director of testing" job page


Scenario Outline: Do not send notification if the applicant updates application (unless accepting offer)
  Given the following job application records
    | applicant | job                  |
    | bob       | Director of testing  |
    | joe       | Director of testing  |
    | monolith  | Director of testing  |

  Given I am logged in as "monolith"
    And no emails have been sent
  When "<applicant>" updates the application message for "Director of testing" job
  Then I should have 0 emails
    And "bob@commune2.com" should have 0 emails
    And "joe@commune2.com" should have 0 emails

Examples:
 | applicant  |
 | bob        |
 | joe        |
 | monolith   |

