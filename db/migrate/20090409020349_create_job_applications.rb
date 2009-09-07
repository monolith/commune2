class CreateJobApplications < ActiveRecord::Migration
  def self.up
    create_table :job_applications do |t|
      t.column :user_id, :integer, :null => false
      t.column :job_id, :integer, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :job_applications
  end
end
