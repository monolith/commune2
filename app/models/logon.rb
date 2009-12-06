class Logon < ActiveRecord::Base
  belongs_to  :user
  attr_accessible :previous

end
