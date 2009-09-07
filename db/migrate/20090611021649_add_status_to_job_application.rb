class AddStatusToJobApplication < ActiveRecord::Migration
  def self.up
      add_column :job_applications, :hired, :boolean, :default => false
      add_column :job_applications, :nominated_by_team_member, :boolean, :default => false
      add_column :job_applications, :offered, :boolean, :default => false


      add_column :jobs, :open, :boolean, :default => true

  end

  def self.down
  
      remove_column :job_applications, :hired
      remove_column :job_applications, :nominated_by_team_member
      remove_column :job_applications, :offered

      remove_column :jobs, :open
  
  
  end
end
