class Rating < ActiveRecord::Base
  belongs_to :scorecard, :counter_cache => true
  belongs_to :user

  validates_presence_of     :scorecard_id
  validates_presence_of     :user_id
  validates_presence_of     :stars

  after_save :adjust_scorecard_rating
  
  
  private
  
  def adjust_scorecard_rating
    scorecard.adjust_rating
  end


  
end
