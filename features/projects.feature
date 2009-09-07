@projects

Feature: Basic project management (note: these are not project management tools)
  In order to start a project and look for projects
  As a user
  I want to be able to post, update, view, and comment on projects

  Background:
    Given the following user records
      | login    |
      | monolith |
      | bob      |

    Given the following idea records
      | author    | title            | active |
      | bob       | Bobs great idea | true   |
      | monolith  | Monolith idea    | true   |
      | monolith  | Inactive idea    | false  |

    Given the following project records
      | author    | title              | active |
      | bob       | Bobs project       | true   |
      | monolith  | Monolithic project | true   |
      | monolith  | Project not active | false  |

  Scenario: Posting a projects without an idea
    Given I am logged in as "monolith"
    When I am on new project page
      And I fill in "project_title" with "Test Project"
      And I fill in "project_description" with "stuff"
      And I check one of the industries
      And I press "Create Project"
    Then I should see "This project has been posted"

   
  Scenario Outline: Posting a project from an idea
    Given I am logged in as "<user>"
    When I go to view "<idea title>" idea
    Then I should see "Launch Project" button
    When I press "Launch Project"
    Then I should see "New Project"
    When I fill in "project_title" with "<project name>"
      And I fill in "project_description" with "stuff"
      And I check one of the industries
      And I press "Create Project"
    Then I should see "This project has been posted"
    When I follow "Projects"
    Then I should see "<project name>"
    
    Examples:
      | user      | idea title       | project name |
      | monolith  | Bobs great idea  | Test 1       |
      | monolith  | Monolith idea    | Test 2       | 
      | monolith  | Inactive idea    | Test 3       | 


  Scenario Outline: Cannot view other users inactive project
    Given I am logged in as "<user>"
    When I go to view "<title>" project
    Then I should <action>
    
    Examples:
      | user      | title              | action                       |
      | monolith  | Bobs project       | see "Bobs project"          |
      | monolith  | Monolithic project | see "Monolithic project"     | 
      | monolith  | Project not active | see "Project not active"     | 
      | bob       | Monolithic project | see "Monolithic project"     | 
      | bob       | Project not active | not see "Project not active" | 


  Scenario Outline: As the creator of a project, I should be able to update it
    Given I am logged in as "monolith"
    When I go to view "<title>" project
      And I follow "Edit Project"
    Then I should see "Edit Project"
    When I fill in "project_wiki" with "thing"
      And I press "Update"
    Then I should see "Changes saved"
    When I go to view "<title>" project
    Then I should see "thing"
      
    Examples:
      | user      | title              |
      | monolith  | Monolithic project | 
      | monolith  | Project not active |


  Scenario Outline: Project should have one member upon creation
    Given the following project records
      | author    | title              | active |
      | monolith  | Monolithic project | true   |
      | bob       | Project not active | false  |

    Then the "<project>" project should have 1 member
      And "<author>" should be a member of <project>
      
    Examples:
      | project             | author    |
      | Monolithic project  | monolith  |
      | Project not active  | bob       | 
