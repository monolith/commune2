class CreateGeneralSkills < ActiveRecord::Migration
  def self.up
    create_table :general_skills do |t|
      t.column :name, :string, :null => false
      t.column :description, :text
      t.timestamps
    end
    
    skills =  ["Active Learning", "Working with new material or information to grasp its implications"],
              ["Active Listening", "Listening to what other people are saying and asking questions as appropriate"],
              ["Complex Problem Solving","Developed capacities used to solve novel, ill-defined problems in complex, real-world settings"],
              ["Coordination","Adjusting actions in relation to others"],
              ["Critical Thinking","Using logic and analysis to identify the strengths and weaknesses of different approaches"],
              ["Equipment Maintenance","Performing routine maintenance and determining when and what kind of maintenance is needed"],
              ["Equipment Selection","Determining the kind of tools and equipment needed to do a job"],
              ["Installation","Installing equipment, machines, wiring, or programs to meet specifications"],
              ["Instructing","Teaching others how to do something"],
              ["Judgement and Decision Making","Weighing the relative costs and benefits of a potential action"],
              ["Learning Strategies","Using multiple approaches when learning or teaching new things"],
              ["Management of Financial Resources","Determining how money will be spent to get the work done, and accounting for these expenditures"],
              ["Management of Material Resources","Obtaining and seeing to the appropriate use of equipment, facilities, and materials needed to do certain work"],
              ["Management of Personnel Resources","Motivating, developing, and directing people as they work, identifying the best people for the job"],
              ["Mathematics","Using mathematics to solve problems"],
              ["Monitoring","Assessing how well one is doing when learning or doing something"],
              ["Negotiation","Bringing others together and trying to reconcile differences"],
              ["Operation and Control","Controlling operations of equipment or systems"],
              ["Operation Monitoring","Watching gauges, dials, or other indicators to make sure a machine is working properly"],
              ["Operations Analysis","Analyzing needs and product requirements to create a design"],
              ["Persuasion","Persuading others to approach things differently"],
              ["Programming","Writing computer programs for various purposes"],
              ["Quality Control Analysis","Conducting tests and inspections of products, services, or processes to evaluate quality or performance"],
              ["Reading Comprehension","Understanding written sentences and paragraphs in work related documents"],
              ["Repairing","Repairing machines or systems using the needed tools"],
              ["Science","Using scientific methods to solve problems"],
              ["Service Orientation","Actively looking for ways to help people"],
              ["Social Perceptiveness","Being aware of others' reactions and understanding why they react the way they do"],
              ["Speaking","Talking to others to effectively convey information"],
              ["Systems Analysis","Determining how a system should work and how changes in conditions, operations, and the environment will affect outcomes."],
              ["Systems Evaluation","Identifying measures or indicators of system performance and the actions needed to improve or correct performance, relative to the goals of the system"],
              ["Technology Design","Generating or adapting equipment and technology to serve user needs"],
              ["Time Management","Managing one's own time and the time of others"],
              ["Troubleshooting","Determining what is causing an operating error and deciding what to do about it"],
              ["Writing","Communicating effectively with others in writing as indicated by the needs of the audience"]

  
          skills.each do |skill|
            GeneralSkill.create :name => skill[0], :description => skill[1]
          end  
    
  end

  def self.down
    drop_table :general_skills
  end
end
