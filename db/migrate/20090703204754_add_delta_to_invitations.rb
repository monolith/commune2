class AddDeltaToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :delta, :text
  end

  def self.down
    remove_column :invitations, :delta
  end
end
