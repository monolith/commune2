@scorecard

 Feature: Basic scorecard functionality
  To get a better sense of what a person is looking at
  a scorecard will provide basic statistics, tracking the following information:
    - rating score
    - number of comments
    - active ideas (for users)
    - active projects (for users, ideas)
    - active open jobs (for users, projects)
    
  ###########################################################################################
  # active members (for projects) is also part of scorecard, but not counted as a scorecard #
  # it is simply tracking number of active members... may want to move this out of here     #
  # and into the project model                                                              #
  ###########################################################################################

#####
  Scenario Outline: A scorecard should be created for every new user, idea, and project
    Given a new <object>
    Then the object should have a scorecard
      And the scorecard should be blank
  
    Examples:
      | object  |
      | user    |
      | idea    |
      | project |

#####
  Scenario: User's active idea count should go up when posting idea(s)
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |
      | monolith  | Monolithic two  |
      
    Then scorecard for user "bob" should have 1 active idea
      And scorecard for user "monolith" should have 2 active ideas

#####
  Scenario: User's/ idea's active project count should go up when posting project(s)
     Given the following project records
      | author    | idea   | title                |
      | bob       | idea a | Woah project         | 
      | monolith  | idea b | Monolithic project   | 
      | monolith  | idea b | Another monolithic   | 
      | monolith  |        | Project with no idea |
     
    Then scorecard for user "bob" should have 1 active project     
      And scorecard for user "monolith" should have 3 active projects
      And scorecard for idea "idea a" should have 1 active project
      And scorecard for idea "idea b" should have 2 active project
     
#####
  Scenario: User's / projects active job count should go up when posting job(s)
    Given the following job records
      | author    | project              | title                |
      | bob       | Woah project         | Santas helper        | 
      | monolith  | Monolithic project   | Director of testing  |
      | monolith  | Monolithic project   | Project Manager      |
  
    Then scorecard for user "bob" should have 1 active job     
      And scorecard for user "monolith" should have 2 active jobs
      And scorecard for project "Woah project" should have 1 active job
      And scorecard for project "Monolithic project" should have 2 active jobs

#####
  Scenario Outline: User / item total comments count should go up when posting comments
    Given the following idea record
      | author    | title           |
      | bob       | Bobs great idea |

    Given the following project records
      | author    | idea            | title               |
      | bob       | Bobs great idea | Woah project        | 
      | monolith  |                 | Monolithic project  | 
      | monolith  |                 | No comment          | 

    Given the following comment records
      | commentator | comment on                    |
      | bob         | idea "Bobs great idea"        |
      | monolith    | idea "Bobs great idea"        |
      | monolith    | idea "Bobs great idea"        |
      | bob         | project "Woah project"        |
      | monolith    | project "Woah project"        |
      | bob         | project "Monolithic project"  |
      | monolith    | project "Monolithic project"  |
      
    Then scorecard for <item> should have <comments count> total comments

    Examples:
      | item                          | comments count  |
      | user "bob"                    | 3               |
      | user "monolith"               | 4               |
      | idea "Bobs great idea"        | 3               |
      | project "Woah project"        | 2               |
      | project "Monolithic project"  | 2               |
      | project "No comment"          | 0               |
      
#####      
  Scenario: Inactive ideas should not count
    Given the following idea records
      | author    | title           | active |
      | bob       | Bobs great idea | false  |
      | monolith  | Monolith idea   | true   |
      | monolith  | Monolithic two  | false  |
      
    Then scorecard for user "bob" should have 0 active ideas
      And scorecard for user "monolith" should have 1 active idea
    
######
  Scenario: Inactive projects should not count
     Given the following project records
      | author    | idea   | title                | active  |
      | bob       | idea a | Woah project         | false   |
      | monolith  | idea b | Monolithic project   | true    |
      | monolith  | idea b | Another monolithic   | false   |
      | monolith  |        | Project with no idea | true    |
     
    Then scorecard for user "bob" should have 0 active projects     
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for idea "idea a" should have 0 active projects
      And scorecard for idea "idea b" should have 1 active project
     
##### 
  Scenario Outline: Project scorecard on (project) creation should have one active member
    Given the following project records
      | title              | active |
      | Monolithic project | true   |
      | Project not active | false  |

    Then scorecard for project "<project>" should have 1 active member
      
    Examples:
      | project             |
      | Monolithic project  | 
      | Project not active  | 
      
      
#####
  Scenario Outline: Inactive members should not count, and members with more than one job on a project should count only once
    Given the following user records
      | login     | active |
      | monolith  | true   |
      | bob       | true   |
      | joe       | true   |
      | allison   | true   |
      | gunner    | true   |
      | crazy     | true   |
      | notactive | false  |

    Given the following project records
      | author    | title              |
      | bob       | Woah project       |
      | monolith  | Monolithic project |
      | monolith  | Blue skies         |
      | monolith  | Rombus             |

    Given the following job records
      | author    | project              | title                    |
      | bob       | Woah project         | Santas helper            |
      | bob       | Woah project         | Sandwich wrapper         |
      | monolith  | Monolithic project   | Director of testing      |
      | monolith  | Blue skies           | Smoke stack checker      |
      | monolith  | Blue skies           | Soda drinker             |
      | monolith  | Blue skies           | Senior chocolate eater   |
      | monolith  | Rombus               | Oh no - notactive person |

    Given the following job application records
      | applicant | job                       | hired |
      | bob       | Director of testing       | true  |
      | joe       | Director of testing       | false |
      | allison   | Santas helper             | true  |
      | gunner    | Sandwich wrapper          | true  |
      | crazy     | Smoke stack checker       | true  |
      | crazy     | Soda drinker              | true  | 
      | monolith  | Senior chocolate eater    | true  |
      | notactive | Oh no - notactive person  | true  |

    # NOTES
    # Although not shown here, the project creators are also members, this happens during project creation
    # joe is not hired, so should not count
    # crazy has two jobs on same project, so should count only once
    # monolith is a project manager, so additional position below should not count
    # notactive is not active - so should not be counted (the count is for active members only)

    Then scorecard for project "<project>" should have <member count> active members
    
    Examples:
      | project            | member count |
      | Woah project       | 3            |
      | Monolithic project | 2            |
      | Blue skies         | 2            |
      | Rombus             | 1            |



#####
  Scenario: Idea: active to inactive and vice versa should affect scorecard count of user
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      
    Then scorecard for user "bob" should have 1 active idea
    Given idea "Bobs great idea" becomes inactive
    Then scorecard for user "bob" should have 0 active ideas

    Given idea "Bobs great idea" becomes active
    Then scorecard for user "bob" should have 1 active ideas

#####

  Scenario: Project: active to inactive and vice versa should affect scorecard count of user and idea
     Given the following project records
      | author    | idea   | title                |
      | monolith  | idea b | Monolithic project   | 
      | monolith  |        | Project with no idea |
      
    Then scorecard for user "monolith" should have 1 active idea
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for idea "idea b" should have 1 active project

    Given project "Monolithic project" becomes inactive
      And project "Project with no idea" becomes inactive
    Then scorecard for user "monolith" should have 1 active idea
      And scorecard for user "monolith" should have 0 active projects
      And scorecard for idea "idea b" should have 0 active projects

    Given project "Monolithic project" becomes active
      And project "Project with no idea" becomes active
    Then scorecard for user "monolith" should have 1 active idea
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for idea "idea b" should have 1 active project

#####

  Scenario: Job: active to inactive and vice versa should affect scorecard count of user and project
    Given the following job records
      | author    | project              | title                |
      | monolith  | Woah project         | Santas helper        | 
      | monolith  | Monolithic project   | Director of testing  |
      | monolith  | Monolithic project   | Program Manager      |
  
    Then scorecard for user "monolith" should have 3 active jobs     
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for project "Woah project" should have 1 active job
      And scorecard for project "Monolithic project" should have 2 active jobs

    Given job "Santas helper" becomes inactive
      And job "Director of testing" becomes inactive
      And job "Program Manager" becomes inactive

    Then scorecard for user "monolith" should have 0 active jobs     
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for project "Woah project" should have 0 active jobs
      And scorecard for project "Monolithic project" should have 0 active jobs

    Given job "Santas helper" becomes active
      And job "Director of testing" becomes active
      And job "Program Manager" becomes active

    Then scorecard for user "monolith" should have 3 active jobs     
      And scorecard for user "monolith" should have 2 active projects
      And scorecard for project "Woah project" should have 1 active job
      And scorecard for project "Monolithic project" should have 2 active jobs

    
#####
  Scenario: User: active to inactive and vice versa should affect scorecard of project (members)
     Given the following project records
      | author    | title                |
      | monolith  | Monolithic project   | 
      
    Then scorecard for user "monolith" should have 1 active project
      And scorecard for project "Monolithic project" should have 1 active member

    Given user "monolith" becomes inactive
    Then scorecard for user "monolith" should have 1 active project
      And scorecard for project "Monolithic project" should have 0 active members

    Given user "monolith" becomes active
    Then scorecard for user "monolith" should have 1 active project
      And scorecard for project "Monolithic project" should have 1 active member
    
#####
  Scenario: Scorecard items when on watchlist (recent items)
    Given pending
