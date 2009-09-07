class RenameUserRepresentsEntityToIndividual < ActiveRecord::Migration
  def self.up
    remove_column :users, :user_represents_entity
    add_column :users, :individual, :boolean, :default => true
    
  end

  def self.down
    remove_column :users, :individual
    add_column :users, :user_represents_entity, :boolean, :default => false

  end
end
