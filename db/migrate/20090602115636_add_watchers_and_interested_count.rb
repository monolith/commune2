class AddWatchersAndInterestedCount < ActiveRecord::Migration
  def self.up
    remove_column :ideas, :watchlists_count
    remove_column :projects, :watchlists_count
    remove_column :ideas, :interests_count
    remove_column :projects, :interests_count
    
    add_column :users, :watchers_count, :integer, :default => 0
    add_column :ideas, :watchers_count, :integer, :default => 0
    add_column :projects, :watchers_count, :integer, :default => 0
    add_column :jobs, :watchers_count, :integer, :default => 0

    add_column :ideas, :interested_count, :integer, :default => 0
    add_column :projects, :interested_count, :integer, :default => 0

    Idea.find(:all).each do |i|
      i.update_attribute :watchers_count, i.watchers.count
      i.update_attribute :interested_count, i.interested.count
    end

    Project.find(:all).each do |i|
      i.update_attribute :watchers_count, i.watchers.count
      i.update_attribute :interested_count, i.interested.count
    end

    User.find(:all).each do |i|
      i.update_attribute :watchers_count, i.watchers.count
    end

  end

  def self.down
    remove_column :users, :watchers_count
    remove_column :ideas, :watchers_count
    remove_column :projects, :watchers_count
    remove_column :jobs, :watchers_count
    remove_column :ideas, :interested_count
    remove_column :projects, :interested_count

    add_column :ideas, :watchlists_count, :integer, :default => 0        
    add_column :projects, :watchlists_count, :integer, :default => 0
    add_column :ideas, :interests_count, :integer, :default => 0        
    add_column :projects, :interests_count, :integer, :default => 0

  end
end
