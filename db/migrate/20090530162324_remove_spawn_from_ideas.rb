class RemoveSpawnFromIdeas < ActiveRecord::Migration
  def self.up
    remove_column :ideas, :spawn_by_others_allowed
  end

  def self.down
    add_column :ideas, :spawn_by_others_allowed, :boolean, :default => false, :null => false
  end
  
end
