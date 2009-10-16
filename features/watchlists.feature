@watchlists

Feature: Watchlist
  In order to track things on the website
  As a logged in user
  I want to add things to my watchlist


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

  Scenario Outline: I should be able to add/remove a person, idea, or project to my watchlist
    When I go to <page>
    Then I should see "start watching"
    When I follow "start watching"
    Then I should see "Added to watchlist"
      And I should see "1 watching"
    When I go to my watchlist
    Then I should see <words>
    When I go to <page>
    Then I should see "stop watching"
    When I click on "stop watching"
    Then I should see "Removed from watchlist"
      And I should see "0 watching"
    When I go to my watchlist
    Then I should not see <words>
    
    Examples:
      | page                          | words            |
      | "joe's" profile               | "joe"            |
      | view "Eat dinner" idea        | "Eat dinner"     |
      | view "Movie channel" project  | "Movie channel"  |
      | view "Blue ice cream" project | "Blue ice cream" |
      

   Scenario Outline: I should not be able to add to watchlist items that I posted
    When I go to <page>
    Then I should not see "Add to Watchlist" button
    
    Examples:
      | page                            |
      | "monolith's" profile            |
      | view "Free HDTV" idea           |
      | view "Baseball channel" project |
      

    Scenario: Other users should not see my watchlist
      # Given in background logs me in as monolith
      When I go to "joe's" profile
        And I follow "start watching"
      Then I should see "Added to watchlist"
      When I go to my watchlist
      Then I should see "joe"
      Given I am logged in as "bob"
      When I go to my watchlist  # this is now bob's watchlist, not monolith
      Then I should not see "joe"
      When I go to "joe's" profile
      Then I should see "1 watching"
        But I should not see "monolith" 
