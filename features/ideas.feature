@ideas

 Feature: Basic idea management
  In order to share and look for ideas
  As a user
  I want to be able to post, update, view, and comment on ideas
    
  Background:
    Given the following user records
      | login    | password |
      | monolith | secret   |
      | bob      | secret   |

        
  Scenario: When I am logged in I should be able to post an idea
    Given I am logged in as "monolith" with password "secret"
      And my scorecard has 0 "active_ideas_count"
    When I go to new idea page
      And I fill in "idea_title" with "My New Idea"
      And I fill in "idea_description" with "My Description"
      And I check one of the industries
      And I press "Post Idea"
    Then I should see "Your idea has been posted"
      And my scorecard should have 1 "active_ideas_count"
    When I go to ideas page
    Then I should see "My New Idea"
    Given I am logged in as "bob" with password "secret"
    When I go to ideas page
    Then I should see "My New Idea"
    
  Scenario: Inactive ideas should not be visible to other users
    Given I am logged in as "monolith" with password "secret"
    When I follow "Ideas"
      And I follow "Post Idea"
      And I choose "idea_active_false"
      And I fill in "idea_title" with "Inactive Idea"
      And I fill in "idea_description" with "My Description"
      And I check one of the industries
      And I press "Post Idea"
    Then I should see "Your idea has been posted"
    When I am on my ideas page
    Then I should see "Inactive Idea"
    Given I am logged in as "bob" with password "secret"
    When I am on ideas page
    Then I should not see "Inactive Idea"
    When I am on my ideas page
    Then I should not see "Inactive Idea"
   
    
  Scenario: Must be logged in to view idea
    Given the following idea records
      | author | title            |
      | bob    | Bobs great idea |

    Given I am logged out
    When I go to view "Bobs great idea" idea
    Then I should not see "Bobs great idea"
      And I should be on redirected to login page
    Given I am logged in as "monolith" with password "secret"
    When I go to view "Bobs great idea" idea
    Then I should see "Bobs great idea"
    
    
  Scenario: I should be able to update my idea
    Given the following idea records
      | author    | title         |
      | monolith  | My great idea |
    
    Given I am logged in as "monolith" with password "secret"
    When I go to view "My great idea" idea
      And I follow "Edit Idea"
    Then I should see "Edit Idea"
    When I fill in "idea_title" with "Updated title"
      And I press "Update"
    Then I should see "Changes saved"
    When I go to view "Updated title" idea
    Then I should see "Updated title"
