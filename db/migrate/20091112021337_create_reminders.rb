class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.column :user_id, :integer, :null => false
      t.column :dashboard, :boolean, :null => false, :default => true
      t.column :dashboard_last_sent_at, :timestamp, :null => true

      t.timestamps
    end
    
    # create dashboard reminder setting, default to off for existing users
    User.all.each do |user|
      user.create_reminder(:dashboard => false)
    end
  end

  def self.down
    drop_table :reminders
  end
end



