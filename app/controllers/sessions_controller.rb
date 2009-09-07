# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!    
    user = User.authenticate(params[:login], params[:password])
    
      if user
        # Protects against session fixation attacks, causes request forgery
        # protection if user resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset_session

          if verify_recaptcha(params)

            self.current_user = user
            new_cookie_flag = (params[:remember_me] == "1")
            handle_remember_cookie! new_cookie_flag
            redirect_back_or_default('/')
            flash[:notice] = "Logged in successfully"

          else
              @login       = params[:login]
              @remember_me = params[:remember_me]
              flash[:error] = "You failed the ReCAPTCHA test, try again"
              redirect_to :back

          end
      else
        note_failed_signin
        @login       = params[:login]
        @remember_me = params[:remember_me]
        render :action => :new
      end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    user = User.find_by_login params[:login]
    message = ""
    if user and !user.active?
      @show_resend_activation_button = true
      message = "- user not activated"
    end
    flash[:error] = "Log in failed, please try again."
    message = ["Failed login for ? from ? at ? ?", params[:login], request.remote_ip, Time.now.utc, message]
    logger.warn  
    

  end
end
