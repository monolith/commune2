@promos

Feature: Joining with a promo code
  In order to let people join without being on the invite list
  As a commune2 admin
  I want to be able to create promo codes that allow people to join

  Background:
    Given the following user records
      | login     | admin |
      | monolith  | true  |
      | bob       | false |


  Scenario: Admins should see link to promo codes from invitations page
    Given I am logged in as "monolith"
      And I am on new invitation page
    Then I should see a link to "Promo Codes"
    When I follow "Promo Codes"
    Then I should be on promos page
    When I am logged in as "bob"
      And I am on new invitation page
    Then I should not see a link to "Promo Codes"

  Scenario: Only admin should have access to promo pages
    Given I am logged in as "monolith"
    When I go to promos page
    Then I should see "Promo Codes"
    When I go to new promo page
    Then I should see "New Code"
    Given I am logged in as "bob"
    When I go to promos page
    Then I should not see "Promo Codes"
      And I should be on the homepage
      And I should see "Access denied"
    When I go to new promo page
    Then I should not see "New Code"
      And I should be on the homepage
      And I should see "Access denied"

  Scenario: Create and update
    Given I am logged in as "monolith"
      And I am on the new promo page
    When I fill in "promo_code" with "secret"
      And I press "Submit"
    Then I should be on the promos page
      And I should see "Successfully created promo"
      And I should see "secret"
    When I follow "Edit"
      And I fill in "promo_code" with "stuff"
      And I press "Submit"
    Then I should see "Successfully updated promo"
      And I should see "stuff"
      But I should not see "secret"


  Scenario: Active and inactive
    Given the following promo records
      | code         |
      | test code    |

    Given I am logged in as "monolith"
      And I am on the promos page
    Then I should see "test code"
      And I should see "active"
    When I follow "Edit"
      And I choose "inactive"
      And I press "Submit"
    Then I should see "Successfully updated promo"
      And I should see "inactive"


  Scenario: Should be able to join with promo code if not on invite list
    Given the following promo records
      | code         |
      | test code    |

    Given I am on the registration page
      And there are one or more users
      And there is no invitation for "not_invited@commune2.com"
    When I fill in "user_login" with "not_invited_user"
      And I fill in "user_email" with "not_invited@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I fill in "idea_title" with "Idea"
      And I fill in "idea_description" with "Description"
      And I fill in "promo_code" with "test code"
      And I press "Register"
    Then I should see "Thank you for registering."


  Scenario: Only active promos should work
    Given the following promo records
      | code      | active  |
      | test code | true    |
      | inactive  | false   |

    Given I am on the registration page
      And there are one or more users
      And there is no invitation for "not_invited@commune2.com"
    When I fill in "user_login" with "not_invited_user"
      And I fill in "user_email" with "not_invited@commune2.com"
      And I fill in "user_password" with "password"
      And I fill in "user_password_confirmation" with "password"
      And I fill in "new_location" with "New York"
      And I fill in "idea_title" with "Idea"
      And I fill in "idea_description" with "Description"
      And I fill in "promo_code" with "inactive"
      And I press "Register"
    Then I should not see "Thank you for registering."
      And I should see "Could not create account"
      And I should see "Promo code not valid"


  Scenario: Should see how many people joined with the promo code
    Given the following promo records
      | code      | active  |
      | test code | true    |
      | another   | false   |

    Given the following user records
      | login     | admin | promo     |
      | monolith  | true  | test code |
      | bob       | false | another   |
      | joe       | false | another   |

    Given I am logged in as "monolith"
    When I go to promos page
    Then I should see "1"
      And I should see "2"
      And "test code" promo should have 1 user
      And "another" promo should have 2 users

