class Promo < ActiveRecord::Base
  validates_presence_of :code
  validates_uniqueness_of :code

  has_many :users

  attr_accessible :code,
                  :active


  def status
    active ? "active" : "inactive"
  end

end

