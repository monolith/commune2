class AddMessageToInvite < ActiveRecord::Migration
  def self.up
      add_column :invitations, :message, :string, :limit => 250

  end

  def self.down
      remove_column :invitations, :message
  end
end
