class CreatePolymorphicGeneralSkills < ActiveRecord::Migration
  def self.up
    create_table :polymorphic_general_skills do |t|
      t.references :object, :polymorphic => true, :null => false
      t.column :general_skill_id, :integer, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :polymorphic_general_skills
  end
end
