
class Invitation < ActiveRecord::Base


  validates_presence_of     :user
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email, :message => "already exists on the invite list.  This person has already registered or can register with this email."
#  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_presence_of     :message
  validates_length_of       :message, :maximum => 250

  validate :invitation_limit_check
  validate :email_not_in_user_table

  
  belongs_to :user # person who sent invitation
  belongs_to :registered, :class_name => "User" # registered person, assuming the person registered and activated profile
    
  attr_accessible :email, :message, :registered_id, :updated_at

  def invitation_limit_check
    errors.add :invitations, "currently not available because you sent the maximum, more will be available later." unless
      user.available_invitations > 0
  end
  
  def email_not_in_user_table
    user_exists = User.find :first, :conditions => ["email = ? or secondary_email = ?", email, email]
    errors.add :email, " is already registered." if user_exists
  end

  def when_sent
    if updated_at > created_at
      "Originally Invited: " << created_at.to_s << " | Resent: " << updated_at.to_s
    else
      "Invited: " << created_at.to_s 
    end
  end
  
  def status
    if registered and registered.active
      "Activated"
    else
      "Inactive"
    end
  end



  private
  
  define_index do
    indexes email
    indexes [registered.first_name, registered.last_name, registered.company, registered.login], :as => :invited
    indexes registered.locations.location, :as => :location

    has user_id
    has created_at
    set_property :delta => true 
  end
  
  
end
