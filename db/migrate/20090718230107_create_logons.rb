class CreateLogons < ActiveRecord::Migration
  def self.up
    create_table :logons do |t|
      t.integer   :user_id, :null => false
      t.datetime :last, :default => Time.now.utc, :null => false
      t.datetime :previous, :default => Time.now.utc, :null => false

      t.timestamps
    end
    
    User.all.each do |user|
      user.create_logon :last => user.updated_at, :previous => user.updated_at
    end
  end

  def self.down
    drop_table :logons
  end
end
