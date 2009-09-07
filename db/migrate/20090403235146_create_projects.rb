class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :active, :boolean, :default => true, :null => false
      t.column :user_id, :integer, :null => false
      t.column :idea_id, :integer
      t.column :name, :string, :limit => 100, :null => false
      t.column :description, :text

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
