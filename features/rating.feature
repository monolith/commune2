@rating

#####################################################################################
# Need to figure out how to actually test clicking on rating - may require Selenium #
#####################################################################################

Feature: Basic rating functionality
  In order to provide feedback to the community
  As a logged in user
  I want to be able to rate users, ideas, and projects

  Scenario: Rating other users
    Given pending
  
  Scenario: Rating other ideas
    Given pending

  Scenario: Rating other projects
    Given pending
  
  Scenario: Cannot rate self or your own ideas and projects
    Given pending
    
    
#############################
# Basic Calculation tests   #
#############################

  Scenario: Various calculations of average and adjusted average
    Given the following user records
      | login     |
      | monolith  |
      | bob       |
      | joe       |
      | maria     |

    Given the following idea record
      | author  | title       |
      | maria   |Great Idea  |

    Given the following project record
      | author  | title              |
      | maria   | Great Project      |
      

    Given the following rating records
      | ratee     | rated                   | stars |
      | monolith  | user "bob"              | 1     |
      | joe       | user "bob"              | 3     |
      | monolith  | idea "Great Idea"       | 2     |
      | bob       | idea "Great Idea"       | 2     |
      | joe       | idea "Great Idea"       | 5     |
      | monolith  | project "Great Project" | 4     |
      | bob       | project "Great Project" | 4     |
      | joe       | project "Great Project" | 4     |
      
    
    Then average rating for user "bob" should be 2
      And average rating for idea "Great Idea" should be 3
      And average rating for project "Great project" should be 4
