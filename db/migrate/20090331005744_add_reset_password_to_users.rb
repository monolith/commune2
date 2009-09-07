class AddResetPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :resend_password, :boolean
  end

  def self.down
    remove_column :users, :resend_password
  end
end
