require 'machinist/active_record'
require 'sham'
require 'faker'


Sham.first_name(:unique => false) { Faker::Name.first_name }
Sham.last_name(:unique => false) { Faker::Name.last_name }
Sham.login { Sham.first_name + '_' + Sham.last_name }
Sham.company(:unique => false) { Faker::Company.name }
Sham.email { Faker::Internet.email }
Sham.word(:unique => false) { Faker::Lorem.words(1) }
Sham.sentence(:unique => false) { Faker::Lorem.sentence[0..49] }
Sham.body(:unique => false) { Faker::Lorem.paragraph[0..249] }

Sham.city(:unique => false) { Faker::Address.city }
Sham.state(:unique => false) { Faker::Address.us_state }
Sham.location { Sham.city + ", " + Sham.state + ", USA" }

User.blueprint do
  # needs to be called with the create method below
  login {Sham.login}
  email {Sham.email}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  company {Sham.company}
  headline {Sham.sentence}
  skills {Sham.body}
  purpose {Sham.body}
  experience {Sham.body}
  education {Sham.body}
  no_cash_ok { rand(2) } # will randomly generate 1 or 0
  currently_available rand(2) # will randomly generate 1 or 0
  individual { rand(2) } # will randomly generate 1 or 0
  active { true }
  admin  { false }
  invited_by_id { 0 }
  password "secret"
  password_confirmation password

end

Idea.blueprint do
  # needs to be called with the create method below
  title { Sham.sentence }
  description { Sham.body }
  active { true }
end


Project.blueprint do
  # needs to be called with the create method below
  title { Sham.sentence }
  description { Sham.body }
  wiki { Sham.body }
  active { true }
end

Job.blueprint do
  # needs to be called with the create method below
  title { Sham.sentence }
  compensation_type { Job.COMPENSATION_TYPES[rand(Job.COMPENSATION_TYPES.length)] }
  description { Sham.body }
  active { true }
  external_publish_ok { true }
#  open { true } # doesn't work, open a reserved word?... will be true be default however
end

JobApplication.blueprint do
  # needs to be called with the create method below
  message { Sham.body }
  offered { false }
  hired { false }
end

Location.blueprint do
  # located is needed, so..
  # need to call this as located.location.make
  # example: user.locations.make

  location { Sham.location }
  country_name "USA" # because the city and state are US-based.. in Sham above
  administrative_area_name { Sham.state }
  locality_name { Sham.city }
  latitude -73.986951 # New York
  longitude 40.756054 # New York
end


Invitation.blueprint do
  user { create_user_with_associations! }
  email { Sham.email }
  message { Sham.body }
  created_at { Time.now.utc }
  registered_id { nil }
  resend_requested { nil }
  resent_at { nil }
end

Comment.blueprint do
  # see create_comment! below
  # user and commentable are populated with that method
  comment { Sham.body }
  created_at { Time.now.utc }
end

Rating.blueprint do
  # see create_comment! below
  # user and commentable are populated with that method
  stars { rand(5) + 1 }
end

Industry.blueprint do
  name {Sham.first_name}
end

RelevantIndustry.blueprint do
  # example: user.relevant_industries.make

  10.times {Industry.make} if Industry.all.size == 0

  industries = Industry.all

  id = rand(industries.size)
  industry { industries[id] }
end


GeneralSkill.blueprint do
  name {Sham.first_name}
  description {Sham.sentence}
end

PolymorphicGeneralSkill.blueprint do
  # example: user.polymorphic_general_skills.make
  10.times {GeneralSkill.make} if GeneralSkill.all.size == 0

  skills = GeneralSkill.all

  id = rand(skills.size)
  general_skill { skills[id] }
end


Icebreaker.blueprint do
  # needs to be called with the create method below
  question { Sham.sentence }
  approved { true }
end



def create_user_with_associations!(attributes = {})

  # clean the hash of nil values
  if attributes.has_key? "user"
    attributes[:user].each_pair { |key, value| attributes[:user].delete key if value == nil  }
  end

  user = User.make_unsaved(attributes[:user])
  user.save(false) # false because it will not like no location

  # ASSOCIATIONS
  # add location
  (rand(2)+1).times { user.locations.make(attributes[:locations]) }

  # add general skills (up to 2)
  (rand(2)+1).times { user.polymorphic_general_skills.make(attributes[:skills]) }

  # add interests (up to 2)
  (rand(2)+1).times { user.relevant_industries.make(attributes[:interests]) }

  return user if user.save! # resaving to make sure the model works
end


def create_idea_with_industries!(attributes = {})

  # check if the user exists, find or create
  # create uses blueprint

  if attributes[:author] && attributes[:author][:login]
    user = User.find_by_login( attributes[:author][:login] ) || create_user_with_associations!( { :user=> attributes[:author] } )
  else
    user = create_user_with_associations!( { :user=> attributes[:author] } )
  end
  idea = user.ideas.make_unsaved(attributes[:idea])
  idea.save(false) # false because it will not like no industries

  # add industries (up to 2)
  (rand(2)+1).times { idea.relevant_industries.make(attributes[:interests]) }

  return idea if idea.save! # resaving to make sure the model works
end


def create_project_with_industries!(attributes = {})
  # check if the user exists, find or create
  # create uses blueprint

  if attributes[:author]
    user = User.find_by_login( attributes[:author][:login] ) || create_user_with_associations!( { :user=> attributes[:author] } )
  else
    user = create_user_with_associations!
  end

  project = user.projects.make_unsaved(attributes[:project])
  if attributes[:idea]
    project.idea = Idea.find_by_title( attributes[:idea][:title] ) || create_idea_with_industries!( { :author => { :login => user.login }, :idea => { :title => attributes[:idea][:title] } } )
  end
  project.save(false) # false because it will not like no industries


  # add industries (up to 2)
  (rand(2)+1).times { project.relevant_industries.make(attributes[:interests]) }

  return project if project.save! # resaving to make sure the model works
end


def create_job_with_skills!(attributes = {})

  # check if the user exists, find or create
  # create uses blueprint

  user = User.find_by_login( attributes[:author][:login] ) || create_user_with_associations!( { :user=> attributes[:author] } )

  job = user.jobs.make_unsaved(attributes[:job])

  if attributes[:project]
    job.project = Project.find_by_title( attributes[:project][:title] ) || create_project_with_industries!( {:project => attributes[:project], :idea => attributes[:idea], :author => attributes[:author] })
  else
    job.project = create_project_with_industries!( { :idea => attributes[:idea], :author => attributes[:author] })
  end

  job.save(false) # false because it will not like no skills

  # add general skills (up to 2)
  (rand(2)+1).times { job.polymorphic_general_skills.make(attributes[:skills]) }

  return job if job.save! # resaving to make sure the model works
end



def create_job_application!(attributes = {})
  # check if these exist, find or create

  user = User.find_by_login( attributes[:applicant][:login] ) || create_user_with_associations!( { :user=> attributes[:applicant] } )

  job = Job.find_by_title( attributes[:job][:title] ) || create_job_with_skills!( { :job=> attributes[:job], :project => attributes[:project] } )

  application = user.job_applications.make_unsaved(attributes[:application])
  application.project = job.project
  application.job = job

  return application if application.save! # resaving to make sure the model works
end


def create_comment!(attributes = {})
  # check if these exist, find or create

  if attributes[:commentator]
    user = User.find_by_login( attributes[:commentator][:login] ) || create_user_with_associations!( { :user=> attributes[:commentator] } )
  else
    user = create_user_with_associations!
  end

  # this code assumes that commentable has a title attributes (e.g. ideas, projects)
  # commentable is required
  commentable = eval(attributes[:commentable][:commentable_type].capitalize).find_by_title attributes[:commentable][:title] || create_on_the_fly(attributes[:commentable][:commentable_type], { :title => attributes[:commentable][:title] })

  comment = user.comments.make_unsaved(attributes[:comment])
  comment.commentable = commentable

  return comment if comment.save! # resaving to make sure the model works
end


def create_rating!(attributes = {})
  # check if these exist, find or create
  if attributes[:ratee]
    user = User.find_by_login( attributes[:ratee][:login] ) || create_user_with_associations!( { :user=> attributes[:ratee] } )
  else
    user = create_user_with_associations!
  end

  rated = case attributes[:rated][:class_name].capitalize
    when "User"
      User.find_by_login( attributes[:rated][:search_query] ) || create_user_with_associations!( { :user=> { :login => [:rated][:search_query] } } )
    when "Idea"

      Idea.find_by_title( attributes[:rated][:search_query] ) || create_idea_with_industries!( { :idea => { :title => attributes[:rated][:search_query] } } )
    when "Project"

      Project.find_by_title( attributes[:rated][:search_query] ) || create_project_with_industries!( { :idea=> { :title => attributes[:rated][:search_query] } } )
  end


  rating = user.ratings.make_unsaved(attributes[:rating])
  rating.scorecard = rated.scorecard

  return rating if rating.save! # resaving to make sure the model works
end



def create_icebreaker_with_author!(attributes = {})
  # check if the user exists, find or create
  # create uses blueprint

  if attributes[:author] && attributes[:author][:login]
    user = User.find_by_login( attributes[:author][:login] ) || create_user_with_associations!( { :user=> attributes[:author] } )
  else
    user = create_user_with_associations!(:user => {:admin => true})
  end

  icebreaker = user.icebreakers.make(attributes[:icebreaker])

end

def create_reminder_with_user!(attributes = {})
  # check if the user exists, find or create
  # create uses blueprint

  if attributes[:user] && attributes[:user][:login]
    user = User.find_by_login( attributes[:user][:login] ) || create_user_with_associations!( { :user=> attributes[:user] } )
  else
    user = create_user_with_associations!( { :user=> attributes[:user] } )
  end

  if attributes[:logon]
    user.logon.update_attributes(attributes[:logon])
  end

  user.reminder.update_attributes(attributes[:reminder])

end


def create_on_the_fly(class_name, attributes = {})
  class_name.capitalize!

  case class_name
    when "User"
      create_user_with_associations!(attributes)
    when "Idea"
      create_idea_with_industries!(attributes)
    when "Project"
      create_project_with_industries!(attributes)
    when "Job"
      create_job_application!(attributes)
    else
      eval(object).make
  end
end

