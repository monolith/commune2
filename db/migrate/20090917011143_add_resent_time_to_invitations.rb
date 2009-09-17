class AddResentTimeToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :resent_at, :datetime, :null => true
    add_column :invitations, :resend_requested, :boolean, :null => true

  end

  def self.down
    remove_column :invitations, :resent_at
    remove_column :invitations, :resend_requested
  end
end
