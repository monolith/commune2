class PolymorphicGeneralSkill < ActiveRecord::Base
  belongs_to :object, :polymorphic => true
  belongs_to :general_skill
  
  after_create :touch
  after_destroy :touch_destroy

  
  def touch 
    object.update_attribute(:updated_at, self.updated_at)
  end

  def touch_destroy
    object.update_attribute(:updated_at, Time.now.utc)
  end

end
