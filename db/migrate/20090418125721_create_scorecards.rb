class CreateScorecards < ActiveRecord::Migration
  def self.up
    create_table :scorecards do |t|
      t.references :scorable, :polymorphic => true, :null => false
      t.column :average, :float, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :scorecards
  end
end
