@dashboard

 Feature: Dashboard
  In order to know what's going on
  As a user
  I want to see stats about my stuff and things i am watching
  


  Scenario: When I am logged in and on the homepage, I should see the dashboard
    Given the following user records
      | login    |
      | monolith |

    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should not see "Dashboard"


  Scenario: I should see how many total recent comments have been posted for my ideas since last logon
    Given the following user records
      | login    | last_logon                   |
      | monolith | Wed Aug 10 03:33:13 UTC 2009 |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |
      | monolith  | Monolithic two  |
      
    Given the following comment records
      | commentator | comment on             | created_at                   |
      | bob         | idea "Bobs great idea" | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | idea "Bobs great idea" | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | idea "Monolith idea"   | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | idea "Monolith idea"   | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | idea "Monolith idea"   | Wed Aug 17 03:33:13 UTC 2009 | 
      | bob         | idea "Monolithic two"  | Wed Aug 17 03:33:13 UTC 2009 | 
      | monolith    | idea "Monolithic two"  | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | idea "Monolithic two"  | Mon Aug 01 03:33:13 UTC 2009 |
      | bob         | idea "Monolithic two"  | Mon Aug 01 03:33:13 UTC 2009 |
      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Comments: 5"
      And I should not see "Dashboard - Watchlist" image
      
      
  Scenario: Recent comments on projects should also be reflected in the count
    Given the following user records
      | login    | last_logon                   |
      | monolith | Wed Aug 10 03:33:13 UTC 2009 |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |

     Given the following project records
      | author    | idea            | title | created_at                    |
      | bob       | Bobs great idea | P1    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  | Bobs great idea | P2    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  | Monolith idea   | P3    | Mon Aug 01 03:33:13 UTC 2009  |
      | bob       | Monolith idea   | P4    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  |                 | P5    | Mon Aug 01 03:33:13 UTC 2009  |
      | bob       |                 | P6    | Mon Aug 01 03:33:13 UTC 2009  |
      
    Given the following comment records
      | commentator | comment on              | created_at                   |
      | bob         | idea "Monolith idea"    | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | project "P1"            | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | project "P2"            | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | project "P2"            | Wed Aug 17 03:33:13 UTC 2009 | 
      | bob         | project "P3"            | Wed Aug 17 03:33:13 UTC 2009 | 
      | bob         | project "P3"            | Wed Aug 03 03:33:13 UTC 2009 | 
      | monolith    | project "P4"            | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | project "P5"            | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | project "P6"            | Wed Aug 17 03:33:13 UTC 2009 |
      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Comments: 5"
      And I should not see "Dashboard - Watchlist" image


  Scenario: Recent watchlists on ideas should be reflected in the count
    Given the following user records
      | login     | last_logon                    |
      | monolith  | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                               |
      | alice     |                               |
      | joe       |                               |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |

    Given the following watchlist records
      | watcher     | watching                | created_at                   |
      | bob         | idea "Monolith idea"    | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | idea "Monolith idea"    | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | idea "Bobs great idea"  | Wed Aug 17 03:33:13 UTC 2009 | 
      | joe         | idea "Monolith idea"    | Wed Aug 03 03:33:13 UTC 2009 | 

      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Watchers: 2"
      And I should not see "Dashboard - Watchlist" image


  Scenario: Recent watchlists on projects should also be reflected in the count
    Given the following user records
      | login     | last_logon                    |
      | monolith  | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                               |
      | alice     |                               |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |

     Given the following project records
      | author    | idea            | title | created_at                    |
      | bob       | Bobs great idea | P1    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  | Bobs great idea | P2    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  | Monolith idea   | P3    | Mon Aug 01 03:33:13 UTC 2009  |
      | bob       | Monolith idea   | P4    | Mon Aug 01 03:33:13 UTC 2009  |
      | monolith  |                 | P5    | Mon Aug 01 03:33:13 UTC 2009  |
      | bob       |                 | P6    | Mon Aug 01 03:33:13 UTC 2009  |

    Given the following watchlist records
      | watcher     | watching              | created_at                   |
      | bob         | idea "Monolith idea"  | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P1"          | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | project "P1"          | Wed Aug 17 03:33:13 UTC 2009 | 
      | bob         | project "P2"          | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P2"          | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | project "P2"          | Wed Aug 17 03:33:13 UTC 2009 | 
      | bob         | project "P3"          | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | project "P4"          | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P4"          | Wed Aug 17 03:33:13 UTC 2009 |
      | bob         | project "P5"          | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P5"          | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P6"          | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | project "P3"          | Wed Aug 03 03:33:13 UTC 2009 |

      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Watchers: 7"
      And I should not see "Dashboard - Watchlist" image


  Scenario: Recent interests in ideas should be reflected in the count
    Given the following user records
      | login     | last_logon                    |
      | monolith  | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                               |
      | alice     |                               |
      | joe       |                               |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |

    Given the following interest records
      | interested  | interesting             | created_at                   |
      | bob         | idea "Monolith idea"    | Wed Aug 17 03:33:13 UTC 2009 |
      | alice       | idea "Monolith idea"    | Wed Aug 17 03:33:13 UTC 2009 |
      | monolith    | idea "Bobs great idea"  | Wed Aug 17 03:33:13 UTC 2009 | 
      | joe         | idea "Monolith idea"    | Wed Aug 03 03:33:13 UTC 2009 | 

      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Interested: 2"
      And I should not see "Dashboard - Watchlist" image


  Scenario: Recent projects launched from my ideas should be reflected in the count
    Given the following user records
      | login     | last_logon                    |
      | monolith  | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                               |
      
    Given the following idea records
      | author    | title           |
      | bob       | Bobs great idea |
      | monolith  | Monolith idea   |

     Given the following project records
      | author    | idea            | title | created_at                    |
      | bob       | Bobs great idea | P1    | Wed Aug 17 03:33:13 UTC 2009  |
      | monolith  | Bobs great idea | P2    | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       | Monolith idea   | P3    | Wed Aug 03 03:33:13 UTC 2009  |
      | bob       | Monolith idea   | P4    | Wed Aug 17 03:33:13 UTC 2009  |
      | bob       | Monolith idea   | P5    | Wed Aug 17 03:33:13 UTC 2009  |
      | monolith  | Monolith idea   | P6    | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                 | P7    | Wed Aug 17 03:33:13 UTC 2009  |
      | monolith  |                 | P8    | Wed Aug 03 03:33:13 UTC 2009  |

      
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Projects (from my ideas): 2"
      And I should not see "Dashboard - Watchlist" image

  Scenario: Recent job application should be reflected in the count
    Given the following user records
      | login     | last_logon                    |
      | monolith  | Wed Aug 10 03:33:13 UTC 2009  |
      | bob       |                               |
      | joe       |                               |

    Given the following job records
      | author    | title                | active  | open  |
      | bob       | Santas helper        | true    | true  |
      | monolith  | Director of testing  | true    | true  |
      | monolith  | Director of hello    | true    | true  |
      
    Given the following job application records
      | applicant | job                 | created_at                    |
      | monolith  | Santas helper       | Wed Aug 17 03:33:13 UTC 2009  |
      | joe       | Santas helper       | Wed Aug 17 03:33:13 UTC 2009  |
      | bob       | Director of testing | Wed Aug 17 03:33:13 UTC 2009  |
      | joe       | Director of testing | Wed Aug 17 03:33:13 UTC 2009  |
      | bob       | Director of hello   | Wed Aug 17 03:33:13 UTC 2009  |
      | joe       | Director of hello   | Wed Aug 03 03:33:13 UTC 2009  |

    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - My Stuff" image
      And I should see "Job Applications: 3"
      And I should not see "Dashboard - Watchlist" image

@focus
  Scenario: I should see how many ideas have been posted by watched users since last logon
    Given the following user records
      | login    | last_logon                   |
      | monolith | Wed Aug 10 03:33:13 UTC 2009 |
      | bob      |                              |
      | alice    |                              |
      | max      |                              |
      
    Given the following idea records
      | author    | title           | created_at                   |
      | bob       | Bobs great idea | Mon Aug 15 03:33:13 UTC 2009 |
      | alice     | idea y          | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | idea x          | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | idea a          | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | idea z          | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith  | idea q          | Mon Aug 01 03:33:13 UTC 2009 |


    Given the following watchlist records
      | watcher     | watching      | created_at                   | 
      | monolith    | user "bob"    | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith    | user "max"    | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | user "alice"  | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | user "bob"    | Mon Aug 01 03:33:13 UTC 2009 |

            
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - Watchlist" image
      And I should see "Ideas: 3"
      And I should not see "Dashboard - My Stuff" image
      

  Scenario: I should see how many projects have been posted by watched and from watched ideas since last logon
    Given the following user records
      | login    | last_logon                   |
      | monolith | Wed Aug 10 03:33:13 UTC 2009 |
      | bob      |                              |
      | alice    |                              |
      | max      |                              |
      
    Given the following idea records
      | author    | title           | created_at                   |
      | bob       | idea x          | Mon Aug 08 03:33:13 UTC 2009 |
      | alice     | idea y          | Mon Aug 08 03:33:13 UTC 2009 |
      | max       | idea z          | Mon Aug 08 03:33:13 UTC 2009 |
      | monolith  | idea q          | Mon Aug 08 03:33:13 UTC 2009 |


    Given the following project records
      | author    | idea            | title           | created_at                   |
      | bob       |                 | P1              | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | idea y          | P2              | Mon Aug 08 03:33:13 UTC 2009 |
      | max       | idea y          | P2              | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | idea z          | P3              | Mon Aug 15 03:33:13 UTC 2009 |
      | max       |                 | P4              | Mon Aug 15 03:33:13 UTC 2009 |
      | alice     |                 | P5              | Mon Aug 15 03:33:13 UTC 2009 |
      | alice     | idea z          | P6              | Mon Aug 15 03:33:13 UTC 2009 |
      | alice     | idea x          | P7              | Mon Aug 08 03:33:13 UTC 2009 |
      | alice     | idea y          | P8              | Mon Aug 08 03:33:13 UTC 2009 |
      | alice     | idea q          | P9              | Mon Aug 08 03:33:13 UTC 2009 |

    Given the following watchlist records
      | watcher     | watching        | created_at                   | 
      | monolith    | user "bob"      | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith    | user "alice"    | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith    | idea "idea y"   | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | user "bob"      | Mon Aug 01 03:33:13 UTC 2009 |

            
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - Watchlist" image
      And I should see "Projects: 4"
      And I should not see "Dashboard - My Stuff" image

      
  Scenario: I should see how many jobs have been posted by watched people and from watched projects since last logon
    Given the following user records
      | login    | last_logon                   |
      | monolith | Wed Aug 10 03:33:13 UTC 2009 |
      | bob      |                              |
      | max      |                              |
      
    Given the following project records
      | author    | title | created_at                   |
      | bob       | P1    | Mon Aug 08 03:33:13 UTC 2009 |
      | max       | P2    | Mon Aug 08 03:33:13 UTC 2009 |
      | max       | P3    | Mon Aug 08 03:33:13 UTC 2009 |

    Given the following job records
      | author    | project   | active  | open  | created_at                   |
      | bob       | P1        | true    | false | Mon Aug 15 03:33:13 UTC 2009 |
      | bob       | P1        | true    | true  | Mon Aug 15 03:33:13 UTC 2009 |
      | bob       | P1        | true    | true  | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | P2        | true    | true  | Mon Aug 15 03:33:13 UTC 2009 |
      | max       | P2        | true    | true  | Mon Aug 08 03:33:13 UTC 2009 |
      | bob       | P1        | true    | true  | Mon Aug 08 03:33:13 UTC 2009 |

    Given the following watchlist records
      | watcher     | watching      | created_at                   | 
      | monolith    | user "bob"    | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith    | project "P1"  | Mon Aug 01 03:33:13 UTC 2009 |
      | monolith    | project "P2"  | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | user "bob"    | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | project "P1"  | Mon Aug 01 03:33:13 UTC 2009 |
      | max         | project "P3"  | Mon Aug 01 03:33:13 UTC 2009 |

            
    Given I am logged in as "monolith"
      And I am on the homepage
    Then I should see "Dashboard - Watchlist" image
      And I should see "Jobs: 3"
      And I should not see "Dashboard - My Stuff" image
      
