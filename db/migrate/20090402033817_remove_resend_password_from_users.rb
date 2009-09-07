class RemoveResendPasswordFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :resend_password
  end

  def self.down
      add_column :users, :resend_password, :boolean
  end
end
