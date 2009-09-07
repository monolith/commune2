class AddAdjustedRatingToScorecard < ActiveRecord::Migration
  def self.up

    add_column :scorecards, :adjusted_rating, :integer, :null => false, :default => 0

    Scorecard.find(:all).each do |s|
      s.adjust_rating
      s.save
    end
  end

  def self.down
    remove_column :scorecards, :adjusted_rating
  end
end
