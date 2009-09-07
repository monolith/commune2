class RelevantIndustry < ActiveRecord::Base
  belongs_to :industrial, :polymorphic => true
  belongs_to :industry
  
  after_create :touch
  after_destroy :touch_destroy

  
  def touch 
    industrial.update_attribute(:updated_at, self.updated_at)
  end

  def touch_destroy
    industrial.update_attribute(:updated_at, Time.now.utc)
  end


end
