class ChangeActiveDefaultForUser < ActiveRecord::Migration
  def self.up
    change_column :users, :active, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :users, :active, :boolean, :default => true, :null => false
  end
end
