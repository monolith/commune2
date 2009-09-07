class Message < ActiveRecord::Base
  belongs_to :from, :class_name => "User"
  belongs_to :to, :class_name => "User"
  
  validates_presence_of     :subject, :body
  validates_length_of       :subject, :within => 0..50
  validates_length_of       :body, :within => 0..500  
  validate  :to_must_be_real_and_active_user, :from_must_be_real_user
  
  after_create :send_message
  
  def to_must_be_real_and_active_user
    if to_id.nil?
        errors.add :recipient, " (to) not specified."    
    else
      u=User.find to_id
      unless u and u.active
        errors.add :recipient, " (to) not found or not active."
      end
    end
  end

  def from_must_be_real_user
    errors.add :person, " (from) not found." if (from_id.nil? || !User.exists?(from_id))
  end


  private

  def send_message
    # really should remove this and take care of this as a background process
    # the reason the record is saved to the database is the assumption
    # that the sender logic will be moved out of here to a background process
    UserMailer.deliver_message(self)      
    self.destroy
  end
end
