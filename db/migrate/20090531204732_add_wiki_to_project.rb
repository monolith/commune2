class AddWikiToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :wiki, :text, :null => true
  end

  def self.down
    remove_column :projects, :wiki
  end
end
