class AddCompensationTypeToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :compensation_type, :text, :null => false

    Job.find(:all).each do |job|
      job.update_attribute(:compensation_type, "Fun, but no pay")
    end
  end

  def self.down
    remove_column :jobs, :compensation_type
  end
end

