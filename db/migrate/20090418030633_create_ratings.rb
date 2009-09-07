class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :scorecard_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :stars, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
