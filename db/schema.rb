# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091112021337) do

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "episodes", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_skills", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icebreakers", :force => true do |t|
    t.integer  "user_id"
    t.string   "question"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.boolean  "active",                          :default => true, :null => false
    t.integer  "user_id",                                           :null => false
    t.string   "title",            :limit => 100,                   :null => false
    t.text     "description",                                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
    t.integer  "watchers_count",                  :default => 0
    t.integer  "interested_count",                :default => 0
  end

  add_index "ideas", ["active"], :name => "index_ideas_on_active"
  add_index "ideas", ["created_at"], :name => "index_ideas_on_created_at"
  add_index "ideas", ["updated_at"], :name => "index_ideas_on_updated_at"
  add_index "ideas", ["user_id"], :name => "index_ideas_on_user_id"

  create_table "industries", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "interest_id",   :null => false
    t.string   "interest_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
  end

  add_index "interests", ["created_at"], :name => "index_interests_on_created_at"
  add_index "interests", ["interest_id"], :name => "index_interests_on_interest_id"
  add_index "interests", ["interest_type"], :name => "index_interests_on_interest_type"
  add_index "interests", ["user_id"], :name => "index_interests_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.string   "email",            :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message",          :limit => 250
    t.integer  "registered_id"
    t.text     "delta"
    t.datetime "resent_at"
    t.boolean  "resend_requested"
  end

  add_index "invitations", ["email"], :name => "index_invitations_on_email", :unique => true
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "job_applications", :force => true do |t|
    t.integer  "user_id",                                                     :null => false
    t.integer  "job_id",                                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message",                  :limit => 1000
    t.boolean  "hired",                                    :default => false
    t.boolean  "nominated_by_team_member",                 :default => false
    t.boolean  "offered",                                  :default => false
    t.integer  "project_id"
  end

  add_index "job_applications", ["job_id"], :name => "index_job_applications_on_job_id"
  add_index "job_applications", ["project_id"], :name => "index_job_applications_on_project_id"
  add_index "job_applications", ["user_id"], :name => "index_job_applications_on_user_id"

  create_table "jobs", :force => true do |t|
    t.boolean  "active",                        :default => true, :null => false
    t.integer  "user_id",                                         :null => false
    t.integer  "project_id"
    t.string   "title",          :limit => 100,                   :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
    t.integer  "watchers_count",                :default => 0
    t.boolean  "open",                          :default => true
  end

  add_index "jobs", ["active"], :name => "index_jobs_on_active"
  add_index "jobs", ["created_at"], :name => "index_jobs_on_created_at"
  add_index "jobs", ["open"], :name => "index_jobs_on_open"
  add_index "jobs", ["project_id"], :name => "index_jobs_on_project_id"
  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "locations", :force => true do |t|
    t.integer  "located_id",                             :null => false
    t.string   "located_type",                           :null => false
    t.string   "location",                 :limit => 90, :null => false
    t.string   "country_name",             :limit => 30
    t.string   "administrative_area_name", :limit => 30
    t.string   "locality_name",            :limit => 30
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
  end

  add_index "locations", ["latitude"], :name => "index_locations_on_latitude"
  add_index "locations", ["located_id"], :name => "index_locations_on_located_id"
  add_index "locations", ["located_type"], :name => "index_locations_on_located_type"
  add_index "locations", ["longitude"], :name => "index_locations_on_longitude"

  create_table "logons", :force => true do |t|
    t.integer  "user_id",                                       :null => false
    t.datetime "last",       :default => '2009-07-19 18:29:59', :null => false
    t.datetime "previous",   :default => '2009-07-19 18:29:59', :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logons", ["user_id"], :name => "index_logons_on_user_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "from_id",                   :null => false
    t.integer  "to_id",                     :null => false
    t.string   "subject",    :limit => 50
    t.text     "body",       :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"
  add_index "messages", ["from_id"], :name => "index_messages_on_from_id"
  add_index "messages", ["to_id"], :name => "index_messages_on_to_id"

  create_table "polymorphic_general_skills", :force => true do |t|
    t.integer  "object_id",        :null => false
    t.string   "object_type",      :null => false
    t.integer  "general_skill_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polymorphic_general_skills", ["general_skill_id"], :name => "index_polymorphic_general_skills_on_general_skill_id"
  add_index "polymorphic_general_skills", ["object_id"], :name => "index_polymorphic_general_skills_on_object_id"
  add_index "polymorphic_general_skills", ["object_type"], :name => "index_polymorphic_general_skills_on_object_type"

  create_table "projects", :force => true do |t|
    t.boolean  "active",                          :default => true, :null => false
    t.integer  "user_id",                                           :null => false
    t.integer  "idea_id"
    t.string   "title",            :limit => 100,                   :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
    t.text     "wiki"
    t.integer  "watchers_count",                  :default => 0
    t.integer  "interested_count",                :default => 0
  end

  add_index "projects", ["active"], :name => "index_projects_on_active"
  add_index "projects", ["created_at"], :name => "index_projects_on_created_at"
  add_index "projects", ["idea_id"], :name => "index_projects_on_idea_id"
  add_index "projects", ["updated_at"], :name => "index_projects_on_updated_at"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "scorecard_id", :null => false
    t.integer  "user_id",      :null => false
    t.integer  "stars",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["scorecard_id"], :name => "index_ratings_on_scorecard_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "relevant_industries", :force => true do |t|
    t.integer  "industrial_id",   :null => false
    t.string   "industrial_type", :null => false
    t.integer  "industry_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relevant_industries", ["industrial_id"], :name => "index_relevant_industries_on_industrial_id"
  add_index "relevant_industries", ["industrial_type"], :name => "index_relevant_industries_on_industrial_type"
  add_index "relevant_industries", ["industry_id"], :name => "index_relevant_industries_on_industry_id"

  create_table "reminders", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.boolean  "dashboard",              :default => true, :null => false
    t.datetime "dashboard_last_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scorecards", :force => true do |t|
    t.integer  "scorable_id",                            :null => false
    t.string   "scorable_type",                          :null => false
    t.float    "average",               :default => 0.0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ratings_count",         :default => 0
    t.text     "delta"
    t.integer  "adjusted_rating",       :default => 0,   :null => false
    t.integer  "total_comments_count",  :default => 0
    t.integer  "active_ideas_count",    :default => 0
    t.integer  "active_projects_count", :default => 0
    t.integer  "active_jobs_count",     :default => 0
    t.integer  "active_members_count",  :default => 0
  end

  add_index "scorecards", ["scorable_id"], :name => "index_scorecards_on_scorable_id"
  add_index "scorecards", ["scorable_type"], :name => "index_scorecards_on_scorable_type"

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.text     "delta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_locations", ["location_id"], :name => "index_user_locations_on_location_id"
  add_index "user_locations", ["user_id"], :name => "index_user_locations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "invited_by_id",                                               :null => false
    t.string   "password_reset_code"
    t.string   "first_name",                :limit => 30
    t.string   "last_name",                 :limit => 30
    t.string   "company",                   :limit => 50
    t.string   "secondary_email",           :limit => 100
    t.string   "headline",                  :limit => 100
    t.text     "delta"
    t.string   "skills",                    :limit => 250
    t.string   "purpose",                   :limit => 500
    t.text     "experience"
    t.text     "education"
    t.boolean  "no_cash_ok",                               :default => true,  :null => false
    t.boolean  "currently_available",                      :default => true,  :null => false
    t.boolean  "active",                                   :default => false, :null => false
    t.integer  "watchers_count",                           :default => 0
    t.boolean  "individual",                               :default => true
    t.boolean  "admin",                                    :default => false, :null => false
  end

  add_index "users", ["active"], :name => "index_users_on_active"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["currently_available"], :name => "index_users_on_currently_available"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["no_cash_ok"], :name => "index_users_on_no_cash_ok"
  add_index "users", ["updated_at"], :name => "index_users_on_updated_at"

  create_table "watchlists", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "watch_id",   :null => false
    t.string   "watch_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delta"
  end

  add_index "watchlists", ["created_at"], :name => "index_watchlists_on_created_at"
  add_index "watchlists", ["user_id"], :name => "index_watchlists_on_user_id"
  add_index "watchlists", ["watch_id"], :name => "index_watchlists_on_watch_id"
  add_index "watchlists", ["watch_type"], :name => "index_watchlists_on_watch_type"


  # populate the db with some data

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


    industries = ['Academia',
                  'Accounting',
                  'Advertising, Public Relations',
                  'Aerospace, Aviation',
                  'Architecture, Design, or Planning',
                  'Arts/Entertainment/Publishing',
                  'Automotive',
                  'Banking',
                  'Biology, Life Sciences',
                  'Broadcasting, Media productions',
                  'Business Development',
                  'Career services',
                  'Clerical, Administrative',
                  'Computers and Programming',
                  'Construction, Facilities',
                  'Consumer Goods',
                  'Customer Service',
                  'Education, Training',
                  'Energy, Utilities',
                  'Engineering',
                  'Environmental Science, Natural Resources',
                  'Government, Politics, and Public Policy',
                  'Hospitality, Travel',
                  'Human Resources',
                  'Installation, Maintenance',
                  'Insurance',
                  'Internet',
                  'Law Enforcement, Security',
                  'Legal',
                  'Library and Information Sciences',
                  'Making the World a Better Place',
                  'Management, Executive',
                  'Manufacturing, Operations',
                  'Marketing',
                  'Mathematics, Statistics',
                  'Medicine, Healthcare',
                  'Military',
                  'Non-Profit, Volunteering',
                  'Pharmaceutical, Biotech',
                  'Physical Sciences',
                  'Professional Services',
                  'Publishing, Journalism',
                  'Quality Control',
                  'Real Estate',
                  'Religion',
                  'Restaurant, Food Service',
                  'Retail',
                  'Sales',
                  'Science, Research',
                  'Skilled Labor',
                  'Social Science or Services',
                  'Sports, Recreation',
                  'Technology',
                  'Telecommunications',
                  'Transportation, Logistics',
                  'Veterinary Services',
                ]
                
    
    industries.each do |industry|
      Industry.create :name => industry
    end


end
