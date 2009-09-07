class CreateRelevantIndustries < ActiveRecord::Migration
  def self.up
    create_table :relevant_industries do |t|
      t.references :industrial, :polymorphic => true, :null => false
      t.column :industry_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :relevant_industries
  end
end
