class IncreaseMessageSizeOnInvitation < ActiveRecord::Migration
  def self.up
    change_column :invitations, :message, :string, :size => 500
  end

  def self.down
    change_column :invitations, :message, :string, :size => 250
  end
end
