class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.column :user_id, :integer, :null => false
      t.column :email, :string, :limit => 100, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
