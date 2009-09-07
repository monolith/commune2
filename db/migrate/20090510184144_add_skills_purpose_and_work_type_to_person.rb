class AddSkillsPurposeAndWorkTypeToPerson < ActiveRecord::Migration
  def self.up
    add_column :users, :skills, :string, :limit => 250
    add_column :users, :purpose, :string, :limit => 500

  end

  def self.down
    remove_column :users, :skills
    remove_column :users, :purpose
  end
end
