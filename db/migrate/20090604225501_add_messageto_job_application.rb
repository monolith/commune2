class AddMessagetoJobApplication < ActiveRecord::Migration
  def self.up
      add_column :job_applications, :message, :string, :limit => 1000
  end

  def self.down
      remove_column :job_applications, :message
  end
end
