class AddDeltaForSearching < ActiveRecord::Migration
  def self.up
    add_column :ideas, :delta, :text
    add_column :projects, :delta, :text
    add_column :jobs, :delta, :text
    add_column :users, :delta, :text
    add_column :scorecards, :delta, :text

  end

  def self.down
    remove_column :ideas, :delta, :text
    remove_column :projects, :delta, :text
    remove_column :jobs, :delta, :text
    remove_column :users, :delta, :text
    remove_column :scorecards, :delta, :text

  end
end
