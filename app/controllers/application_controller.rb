
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0340da3f28c196833a0c37e8d8fbf5d8'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password



  $ALL_GENERAL_SKILLS = GeneralSkill.find :all, :order => :name || []
  $ALL_INDUSTRIES  = Industry.find :all, :order => :name || []


  def update_login_time
    current_user.logged_in_now!
  end
  

end
