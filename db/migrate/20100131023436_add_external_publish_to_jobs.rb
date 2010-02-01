class AddExternalPublishToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :external_publish_ok, :boolean, :default => false, :null => false

    Job.find(:all).each do |job|
      job.update_attribute(:external_publish_ok, false)
    end

  end

  def self.down
    remove_column :jobs, :external_publish_ok
  end
end

