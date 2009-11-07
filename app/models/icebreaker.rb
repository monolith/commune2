class Icebreaker < ActiveRecord::Base
  validate :user_must_be_admin

  belongs_to :user
  attr_accessible :user_id, :question, :approved

  def self.random(count = 3) # 3 set as default
    find :all, :limit => count.to_i, :conditions => "approved", :order => "rand()" # uses mysql function
  end
  
  
  private
  
  def user_must_be_admin
    errors.add_to_base("You don't have administrator rights") unless user.admin?
  end
end
