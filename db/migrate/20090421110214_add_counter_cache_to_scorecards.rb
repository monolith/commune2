class AddCounterCacheToScorecards < ActiveRecord::Migration
  def self.up
    add_column :scorecards, :ratings_count, :integer, :default => 0
    Scorecard.find(:all).each do |s|
      s.update_attribute :scorecard_count, s.ratings.length
    end
  end

  def self.down
    remove_column :scorecards, :ratings_count
  end
end
