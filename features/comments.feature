@comments

Feature: Posting comments
  In order to give people feedback
  As a logged in user
  I want to post comments


  Background:
    Given the following user records
      | login     | password |
      | monolith  | secret   |
      | bob       | secret   |
      | joe       | secret   |
      
    Given the following idea records
      | author    | title                     |
      | bob       | Kitty cat snacks for dogs |
      | monolith  | Free HDTV                 |
      
    Given the following project records
      | author    | idea      | title              |
      | monolith  | Free HDTV | Baseball channel   |
      | bob       | Free HDTV | Movie channel      |
      | bob       |           | Blue ice cream     |


    Scenario Outline: Adding comment on idea or project
      Given I am logged in as "monolith"
      When I go to <page>
      Then I should see "Post Comment" button
      When I fill in "newcomment" with "This is awesome!"
        And I press "Post Comment"
      Then I should see "Comment added"
      When I go to <page>
      Then I should see "This is awesome!"
      Given I am logged in as "bob"
      When I go to <page>
      Then I should see "This is awesome!"
      Given I am logged in as "joe"
      When I go to <page>
      Then I should see "1 Comment"
        And I should see "This is awesome!"
      
      Examples:
        | page                                  |
        | view "Kitty cat snacks for dogs" idea |
        | view "Free HDTV" idea                 |
        | view "Baseball channel" project       |
        | view "Movie channel" project          |
        | view "Blue ice cream" project         |
        
      
    Scenario Outline: Multiple comments
      Given I am logged in as "monolith"
        And I am on <page>
      Then I should see "0 Comments"
      When I fill in "newcomment" with "This is awesome!"
        And I press "Post Comment"
      Then I should see "Comment added"
      Given I am logged in as "bob"
        And I am on <page>
      When I fill in "newcomment" with "Yes, it is!"
        And I press "Post Comment"
      Then I should see "Comment added"
      Given I am logged in as "monolith"
        And I am on <page>
      When I fill in "newcomment" with "You betcha!"
        And I press "Post Comment"
      Then I should see "Comment added"
      Given I am logged in as "joe"
        And I am on <page>
      Then I should see "3 Comments"
        And I should see "This is awesome!"
        And I should see "Yes, it is!"
        And I should see "You betcha!"
      
      Examples:
        | page                                  |
        | view "Kitty cat snacks for dogs" idea |
        | view "Blue ice cream" project         |

