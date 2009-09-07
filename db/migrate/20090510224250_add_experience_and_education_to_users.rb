class AddExperienceAndEducationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :experience, :text, :limit => 2000
    add_column :users, :education, :text, :limit => 500

  end

  def self.down
    remove_column :users, :experience
    remove_column :users, :education
  end
end
