class AddProjectIdToJobApplications < ActiveRecord::Migration
  def self.up
    add_column :job_applications, :project_id, :integer, :null => true
    
    apps = JobApplication.find :all
    apps.each do |a|
      a.project_id = a.job.project_id
      a.save
    end
  end

  def self.down
    remove_column :job_applications, :project_id
  end
end
