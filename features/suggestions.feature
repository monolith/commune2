@suggestions
Feature: Suggestion box

  In order figure out how to improve commune2
  As a commune2 developer
  I want people to submit and rate commune2 enhancement requests

  Background:
    Given the following user records
      | login    |
      | monolith |
      | bob      |

    Given the following suggestion records
      | author    | description                                   |
      | monolith  | send an email when I my friend accepts invite |
      | bob       | mutliple ideas per project                    |


  Scenario: Suggestion box on main menu
    Given I am logged out
      And I am on the homepage
    Then I should not see "suggestion box"
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "suggestion box"
    When I click on "suggestion box"
    Then I should see "send an email when I my friend accepts invite"
      And I should see "mutliple ideas per project"



  Scenario: Submit suggestion through suggestion idea page
    Given I am logged in as "monolith"
      And I am on the suggestions page
    Then I should see "Suggest something!"
    When I fill in "idea_title" with "Another suggestion"
      And I fill in "idea_description" with "more notifications"
      And I press "Suggest"
    Then I should see "Thank you for your suggestion"
      And my scorecard should have 2 "active_ideas_count"
    When I go to suggestions page
    Then I should see "Another suggestion"
      And I should see "more notifications"
    When I am logged in as "bob"
      And I go to the suggestions page
    Then I should see "Another suggestion"
      And I should see "more notifications"

@focus

  Scenario: Submit suggestion through regular idea page
    Given I am logged in as "monolith"
    When I go to new idea page
      And I fill in "idea_title" with "from idea page"
      And I fill in "idea_description" with "this should work"
      And I check "Commune2 Enhancement"
      And I press "Post Idea"
    Then I should see "Your idea has been posted"
    When I go to suggestions page
    Then I should see "from idea page"
      And I should see "this should work"


  Scenario: Suggestions should appear on regular ideas page
    Given I am logged in as "monolith"
      And I am on the ideas page
    Then I should see "send an email when I my friend accepts invite"
      And I should see "mutliple ideas per project"

