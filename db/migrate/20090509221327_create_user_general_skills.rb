class CreateUserGeneralSkills < ActiveRecord::Migration
  def self.up
    create_table :user_general_skills do |t|
      t.column :user_id, :integer, :null => false
      t.column :general_skill_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :user_general_skills
  end
end
