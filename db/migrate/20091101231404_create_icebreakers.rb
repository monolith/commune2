class CreateIcebreakers < ActiveRecord::Migration
  def self.up
    create_table :icebreakers do |t|
      t.integer :user_id
      t.string  :question
      t.boolean :approved
      t.timestamps
    end
  end
  
  def self.down
    drop_table :icebreakers
  end
end
