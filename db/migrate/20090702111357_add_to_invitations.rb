class AddToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :registered_id, :integer, :null => true
  end

  def self.down
    remove_column :invitations, :registered_id
  end
end
