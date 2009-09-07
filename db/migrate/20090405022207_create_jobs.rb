class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :active, :boolean, :default => true, :null => false
      t.column :user_id, :integer, :null => false
      t.column :project_id, :integer
      t.column :title, :string, :limit => 100, :null => false
      t.column :description, :text

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
