class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.column :user_id, :integer, :null => false
      t.references :interest, :polymorphic => true, :null => false
      t.timestamps


      add_column :ideas, :interests_count, :integer, :default => 0
      Idea.find(:all).each do |i|
        i.update_attribute :interests_count, 0
      end
          
      add_column :projects, :interests_count, :integer, :default => 0
      Project.find(:all).each do |i|
        i.update_attribute :interests_count, 0
      end

    end
  end



  def self.down
    drop_table :interests

    remove_column :ideas, :interests_count
    remove_column :projects, :interests_count

  end
end
