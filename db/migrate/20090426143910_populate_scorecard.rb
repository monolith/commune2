class PopulateScorecard < ActiveRecord::Migration
  def self.up
      User.find(:all).each do |x|
        x.build_scorecard
        x.save
      end
    
      Idea.find(:all).each do |x|
        x.build_scorecard
        x.save
      end

      Project.find(:all).each do |x|
        x.build_scorecard
        x.save
      end
    
  end

  def self.down
  end
end
