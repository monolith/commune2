@interests

Feature: Interest (showing interest in things)
  To let people know I am interested in some idea or project,
  I should be able to add them to my interested list, and at the same time
  Let others know that I am interested in this.
  
  This means that any one looking at the idea or project should be able
  to see that I am interested, as well as anyone else who may be interested. 

  Further, when I show interest, the item should be added to my watchlist automatically.
  However, I should be able to remove it from my watchlist, while still showing interest.

  Background:
    Given the following user records
      | login     | password |
      | monolith  | secret   |
      | bob       | secret   |
      | joe       | secret   |
      
    Given the following idea records
      | author    | title                     |
      | joe       | Eat dinner                |
      | bob       | Kitty cat snacks for dogs |
      | monolith  | Free HDTV                 |
      
    Given the following project records
      | author    | idea      | title              |
      | monolith  | Free HDTV | Baseball channel   |
      | joe       | Free HDTV | Movie channel      |
      | joe       |           | Blue ice cream     |

    Given I am logged in as "monolith"


  Scenario Outline: I should be able to show (and stop showing) interest in idea or project
    When I go to <page>
    Then I should see "show interest"
    When I click on "show interest"
    Then I should see "Thank you for showing interest"
      And I should see "1 watching"
      And I should see "1 interested"
    When I go to my watchlist
    Then I should see <words>
    When I go to my interested list
    Then I should see <words>    
    When I go to <page>
    Then I should see "end interest"
    When I click on "end interest"
    Then I should see "You are no longer showing interest."
      And I should see "1 watching"
      And I should see "0 interested"
    When I go to my interested list
    Then I should not see <words>
    
    Examples:
      | page                          | words            |
      | view "Eat dinner" idea        | "Eat dinner"     |
      | view "Movie channel" project  | "Movie channel"  |
      | view "Blue ice cream" project | "Blue ice cream" |
      
	
   Scenario Outline: I should not be able to show interest in items I posted
    When I go to <page>
    Then I should not see "Show Interest" button
    
    Examples:
      | page                            |
      | view "Free HDTV" idea           |
      | view "Baseball channel" project |

      
    Scenario: Other users should be able to see what I am interested in
      # Given in background logs me in as monolith
      When I go to view "Movie channel" project
        And I click on "show interest"
      Then I should see "Thank you for showing interest"
      Given I am logged in as "bob"
      When I go to my interested list
      Then I should not see "Movie channel"
      When I go to view "Movie channel" project
      Then I should see "monolith"
 
