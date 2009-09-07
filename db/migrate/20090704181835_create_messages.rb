class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :from_id, :null => false
      t.integer :to_id, :null => false
      t.string :subject, :limit => 50
      t.text :body, :limit => 250

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
