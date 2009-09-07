class CreateWatchlists < ActiveRecord::Migration
  def self.up
    create_table :watchlists do |t|
      t.column :user_id, :integer, :null => false
      t.references :watch, :polymorphic => true, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :watchlists
  end
end
