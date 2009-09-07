class AddInvitedByToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invited_by_id, :integer, :null => false

  end

  def self.down
    remove_column :users, :invited_by_id
  end
end
