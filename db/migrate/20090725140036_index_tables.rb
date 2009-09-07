class IndexTables < ActiveRecord::Migration
  def self.up
    add_index :ideas, :user_id
    add_index :ideas, :active
    add_index :ideas, :created_at
    add_index :ideas, :updated_at

    add_index :interests, :user_id
    add_index :interests, :interest_type
    add_index :interests, :interest_id
    add_index :interests, :created_at

    add_index :invitations, :user_id
    add_index :invitations, :email, :unique => true
    
    add_index :job_applications, :user_id
    add_index :job_applications, :job_id
    add_index :job_applications, :project_id
    
    add_index :jobs, :user_id
    add_index :jobs, :project_id
    add_index :jobs, :active
    add_index :jobs, :open
    add_index :jobs, :created_at

    add_index :locations, :located_type
    add_index :locations, :located_id
    add_index :locations, :latitude
    add_index :locations, :longitude
    
    add_index :logons, :user_id, :unique => true

    add_index :messages, :from_id
    add_index :messages, :to_id
    add_index :messages, :created_at

    add_index :polymorphic_general_skills, :object_type
    add_index :polymorphic_general_skills, :object_id
    add_index :polymorphic_general_skills, :general_skill_id

    add_index :projects, :active
    add_index :projects, :user_id
    add_index :projects, :idea_id
    add_index :projects, :created_at
    add_index :projects, :updated_at

    add_index :ratings, :scorecard_id
    add_index :ratings, :user_id

    add_index :relevant_industries, :industrial_type
    add_index :relevant_industries, :industrial_id
    add_index :relevant_industries, :industry_id

    add_index :scorecards, :scorable_type
    add_index :scorecards, :scorable_id

    add_index :user_locations, :user_id
    add_index :user_locations, :location_id

    add_index :users, :active
    add_index :users, :no_cash_ok
    add_index :users, :currently_available
    add_index :users, :updated_at
    add_index :users, :created_at

    add_index :watchlists, :user_id
    add_index :watchlists, :watch_type
    add_index :watchlists, :watch_id
    add_index :watchlists, :created_at
  end

  def self.down
    remove_index :ideas, :user_id
    remove_index :ideas, :active
    remove_index :ideas, :created_at
    remove_index :ideas, :updated_at

    remove_index :interests, :user_id
    remove_index :interests, :interest_type
    remove_index :interests, :interest_id
    remove_index :interests, :created_at

    remove_index :invitations, :user_id
    remove_index :invitations, :email, :unique => true
    
    remove_index :job_applications, :user_id
    remove_index :job_applications, :job_id
    remove_index :job_applications, :project_id
    
    remove_index :jobs, :user_id
    remove_index :jobs, :project_id
    remove_index :jobs, :active
    remove_index :jobs, :open
    remove_index :jobs, :created_at
    remove_index :jobs, :updated_at

    remove_index :locations, :located_type
    remove_index :locations, :located_id
    remove_index :locations, :latitude
    remove_index :locations, :longitude
    
    remove_index :logons, :user_id, :unique => true

    remove_index :messages, :from_id
    remove_index :messages, :to_id
    remove_index :messages, :created_at

    remove_index :polymorphic_general_skills, :object_type
    remove_index :polymorphic_general_skills, :object_id
    remove_index :polymorphic_general_skills, :general_skill_id

    remove_index :projects, :active
    remove_index :projects, :user_id
    remove_index :projects, :idea_id
    remove_index :projects, :created_at
    remove_index :projects, :updated_at

    remove_index :ratings, :scorecard_id
    remove_index :ratings, :user_id

    remove_index :relevant_industries, :industrial_type
    remove_index :relevant_industries, :industrial_id
    remove_index :relevant_industries, :industry_id

    remove_index :scorecards, :scorable_type
    remove_index :scorecards, :scorable_id

    remove_index :user_locations, :user_id
    remove_index :user_locations, :location_id

    remove_index :users, :active
    remove_index :users, :no_cash_ok
    remove_index :users, :currently_available

    remove_index :watchlists, :user_id
    remove_index :watchlists, :watch_type
    remove_index :watchlists, :watch_id
    remove_index :watchlists, :created_at
    
  end
end
