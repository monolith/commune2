class AddWatchingCounterCache < ActiveRecord::Migration
  def self.up
    # adds watching counter cache to ideas, projects, jobs  
    add_column :ideas, :watchlists_count, :integer, :default => 0
    Idea.find(:all).each do |i|
      i.update_attribute :watchlists_count, i.watching.count
    end
        
    add_column :projects, :watchlists_count, :integer, :default => 0
    Project.find(:all).each do |i|
      i.update_attribute :watchlists_count, i.watching.count
    end

  end

  def self.down
    remove_column :ideas, :watchlists_count
    remove_column :projects, :watchlists_count
  end
end
