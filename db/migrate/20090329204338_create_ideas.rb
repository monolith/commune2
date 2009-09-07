class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.column :active, :boolean, :default => true, :null => false
      t.column :user_id, :integer, :null => false
      t.column :spawn_by_others_allowed, :boolean, :default => false, :null => false
      t.column :title, :string, :limit => 100, :null => false
      t.column :description, :text, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :ideas
  end
end
