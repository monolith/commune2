
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require "populator"
    require "faker"

INDUSTRIES = ["Academia",
              "Accounting",
              "Advertising, Public Relations",
              "Aerospace, Aviation",
              "Architecture, Design, or Planning",
              "Arts/Entertainment/Publishing",
              "Automotive",
              "Banking",
              "Biology, Life Sciences",
              "Broadcasting, Media productions",
              "Business Development",
              "Career services",
              "Clerical, Administrative",
              "Computers and Programming",
              "Construction, Facilities",
              "Consumer Goods",
              "Customer Service",
              "Education, Training",
              "Energy, Utilities",
              "Engineering",
              "Environmental Science, Natural Resources",
              "Government, Politics, and Public Policy",
              "Hospitality, Travel",
              "Human Resources",
              "Installation, Maintenance",
              "Insurance",
              "Internet",
              "Law Enforcement, Security",
              "Legal",
              "Library and Information Sciences",
              "Making the World a Better Place",
              "Management, Executive",
              "Manufacturing, Operations",
              "Marketing",
              "Mathematics, Statistics",
              "Medicine, Healthcare",
              "Military",
              "Non-Profit, Volunteering",
              "Pharmaceutical, Biotech",
              "Physical Sciences",
              "Professional Services",
              "Publishing, Journalism",
              "Quality Control",
              "Real Estate",
              "Religion",
              "Restaurant, Food Service",
              "Retail",
              "Sales",
              "Science, Research",
              "Skilled Labor",
              "Social Science or Services",
              "Sports, Recreation",
              "Technology",
              "Telecommunications",
              "Transportation, Logistics",
              "Veterinary Services",
              "Just for fun",
              "Saving the planet",
              "Human betterment",
              "Commune2 enhancement" ]

SKILLS = [  {:name => "Active Learning", :description => "Working with new material or information to grasp its implications"},
            {:name => "Active Listening", :description => "Listening to what other people are saying and asking questions as appropriate"},
            {:name => "Complex Problem Solving", :description => "Developed capacities used to solve novel, ill-defined problems in complex, real-world settings"},
            {:name => "Coordination", :description => "Adjusting actions in relation to others"},
            {:name => "Critical Thinking", :description => "Using logic and analysis to identify the strengths and weaknesses of different approaches"},
            {:name => "Equipment Maintenance", :description => "Performing routine maintenance and determining when and what kind of maintenance is needed"},
            {:name => "Equipment Selection", :description => "Determining the kind of tools and equipment needed to do a job"},
            {:name => "Installation", :description => "Installing equipment, machines, wiring, or programs to meet specifications"},
            {:name => "Instructing", :description => "Teaching others how to do something"},
            {:name => "Judgement and Decision Making", :description => "Weighing the relative costs and benefits of a potential action"},
            {:name => "Learning Strategies", :description => "Using multiple approaches when learning or teaching new things"},
            {:name => "Management of Financial Resources", :description => "Determining how money will be spent to get the work done, and accounting for these expenditures"},
            {:name => "Management of Material Resources", :description => "Obtaining and seeing to the appropriate use of equipment, facilities, and materials needed to do certain work"},
            {:name => "Management of Personnel Resources", :description => "Motivating, developing, and directing people as they work, identifying the best people for the job"},
            {:name => "Mathematics", :description => "Using mathematics to solve problems"},
            {:name => "Monitoring", :description => "Assessing how well one is doing when learning or doing something"},
            {:name => "Negotiation", :description => "Bringing others together and trying to reconcile differences"},
            {:name => "Operation and Control", :description => "Controlling operations of equipment or systems"},
            {:name => "Operation Monitoring", :description => "Watching gauges, dials, or other indicators to make sure a machine is working properly"},
            {:name => "Operations Analysis", :description => "Analyzing needs and product requirements to create a design"},
            {:name => "Persuasion", :description => "Persuading others to approach things differently"},
            {:name => "Programming", :description => "Writing computer programs for various purposes"},
            {:name => "Quality Control Analysis", :description => "Conducting tests and inspections of products, services, or processes to evaluate quality or performance"},
            {:name => "Reading Comprehension", :description => "Understanding written sentences and paragraphs in work related documents"},
            {:name => "Repairing", :description => "Repairing machines or systems using the needed tools"},
            {:name => "Science", :description => "Using scientific methods to solve problems"},
            {:name => "Service Orientation", :description => "Actively looking for ways to help people"},
            {:name => "Social Perceptiveness", :description => "Being aware of others' reactions and understanding why they react the way they do"},
            {:name => "Speaking", :description => "Talking to others to effectively convey information"},
            {:name => "Systems Analysis", :description => "Determining how a system should work and how changes in conditions, operations, and the environment will affect outcomes."},
            {:name => "Systems Evaluation", :description => "Identifying measures or indicators of system performance and the actions needed to improve or correct performance, relative to the goals of the system"},
            {:name => "Technology Design", :description => "Generating or adapting equipment and technology to serve user needs"},
            {:name => "Time Management", :description => "Managing one''s own time and the time of others"},
            {:name => "Troubleshooting", :description => "Determining what is causing an operating error and deciding what to do about it"},
            {:name => "Writing", :description => "Communicating effectively with others in writing as indicated by the needs of the audience"}
]


    puts "DESTROYING GeneralSkills and Industries..."
    [GeneralSkill, Industry].each(&:destroy_all)

    puts "CREATING GeneralSkills..."
    GeneralSkill.populate SKILLS.size do |skill|
      skill.name = SKILLS[skill.id-1][:name]
      skill.description = SKILLS[skill.id-1][:description]
      puts "Skill: #{skill.name}"
    end

    puts "CREATING Industries..."
    Industry.populate INDUSTRIES.size do |industry|
      industry.name = INDUSTRIES[industry.id - 1]
      puts "Industry: #{industry.name}"
    end



  end
end

