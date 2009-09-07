class ExtendProfile < ActiveRecord::Migration
  def self.up
         
    remove_column :users, :name
    add_column :users, :first_name, :string, :limit => 30
    add_column :users, :last_name, :string, :limit => 30
    add_column :users, :company, :string, :limit => 50
    add_column :users, :secondary_email, :string, :limit => 100
    add_column :users, :headline, :string, :limit => 100
    
  end

  def self.down
    add_column :users, :name, :string, :limit => 40
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :secondary_email
    remove_column :users, :headline
  end
end
