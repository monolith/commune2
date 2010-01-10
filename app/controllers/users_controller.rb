class UsersController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ :new, :create, :activate, :forgot_password, :reset_password, :resend_activation_link ]
  # render new.rhtml
  def new
    @user = User.new(:email => params[:email])
    @idea = Idea.new
  end

  def create
    logout_keeping_session!
    # check passcode to confirm this person was invited.  This is basic hard coded thing, will need to be replaced.
      @user = User.new(params[:user])
      @idea = Idea.new(params[:idea])
      
    # will need to add javascript support to make the lookups via user browser possible, to reduce number of requests from single IP
      @new_location = params[:location_select] || params[:new_location].strip

      if @user
        @invitation = Invitation.find_by_email(@user.email)
        if @invitation || User.count == 0
          if @invitation
            @user.invited_by_id = @invitation.user_id
          else
            @user.invited_by_id = 0
          end


           if verify_recaptcha(params)

              if params[:location_select] || @new_location && @new_location.length > 0
                @location = Locate.new params[:location_select] || @new_location
                add_location = @location.add @user

                if add_location[:status] == true 
                  location_changed = true
                else
                  location_changed = false
                  flash[:error] = "Account has NOT been created.  Please narrow location."
                  
                  @user.errors.add(:location, add_location[:message])
                  render :action => 'new'                  

                  return
                end
              end             
     
              # add industry
              @idea.industries << (Industry.find_by_name("Just for fun") || Industry.find(:first)) # prevents an error if name changes
              # check if idea is valid
              unless @idea.valid?
                if @idea.errors[:title]
                  @user.errors.add_to_base("Idea title " + @idea.errors[:title])
                end

                if @idea.errors[:description]
                  @user.errors.add_to_base("Idea description " + @idea.errors[:description])
                end
              end

              
              if @user.errors.empty? and @user.save
                flash[:notice] = "Thank you for registering."
                flash[:special_attention_notice] = "An activation link will be sent to " + @user.email + " shortly.  You will be able to log in only after you activate your account.  Please check your email."
                

                @user.ideas << @idea
                @idea.save(false) # validations already done above
                redirect_to :login
              else                
                flash[:error]  = "Your registration attempt failed.  Try again."
                render :action => :new
              end
           else
                flash[:error]  = "You failed the ReCaptcha test."
                render :action => :new
           end
       else
          flash[:error]  = "Could not register.  You must be invited to join this network before you can register."
          @user.errors.add(:email, " #{ '(' + @user.email + ')' if @user.email.length > 0 } not found on the invitation list.")
          render :action => 'new'
       end
    else
      flash[:error]  = "Your registration attempt failed."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:special_attention_notice] = "Your account has been activated.  You are now ready to log in!"
      redirect_to :login

    when params[:activation_code].blank?
      flash[:error] = "The activation code is missing.  Please follow the URL from your email."
      redirect_to :login

    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to :login
    end
  end

  def index
    if params[:search]
      @profiles = User.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
        :include       => [ :scorecard ],
        :field_weights => {
            "person" => 5,
            "headline" => 4,
            "purpose" => 3,
            "skills" => 2,
            "experience" => 2,
            "education" => 2
        },
        :match_mode    => :extended,
        :page          => params[:page],
        :order         => "@relevance DESC, adjusted_rating DESC, watchers_count DESC, last_logon DESC" 
    
    else
      @profiles = User.get('active', 'login asc', params[:page])
    end
  end

  def show

    @user = User.find_by_login params[:id],
                :include => [:active_ideas, :active_projects, :active_positions, :open_job_postings, 
                  :scorecard, :interests, :general_skills, :industries, :locations ],
                :conditions => "active"
                            
    unless @user
      flash[:error] = "Profile for #{params[:id] } is currently inactive or doesn't exist."
    end

  end
  
  
  def edit

    @user = User.find_by_login params[:id]
    
    unless @user == current_user
      flash[:error] = "This is not your profile, you cannot edit it!"
      redirect_to user_path(@user)   
      return 
    end
    
    @industry_ids = @user.industry_ids
    @skill_ids = @user.general_skill_ids
        
  end


  def update
    params[:password] ||= {}
  
    @user = User.find current_user.id
    @industry_ids = (params[:industry_ids] || {}).keys.collect{|s| s.to_i}
    @skill_ids = (params[:skill_ids] || {}).keys.collect{|s| s.to_i}
    @new_location = params[:new_location].strip
    

    # IMPORTANT
    # to update correctly, attribute must be in attr_accessible in the user model!
    @user.attributes = params[:user] # does not save, update_attributes would save, but want to authenticate before saving
    # reason for this is to make sure all entered values are displayed even if there is a bad password
                                     
    if User.authenticate(current_user.login, params[:password])

      success = @user.save
      success = Industry.update_industries(:object=> @user, :industry_ids => @industry_ids) && success
      success = GeneralSkill.update_general_skills(:object=> @user, :skill_ids => @skill_ids) && success

      success = @user.reminder.update_attributes(params[:reminder]) && success


      # will need to add javascript support to make the lookups via user browser possible, to reduce number of requests from single IP
       if params[:location_select] || @new_location and @new_location.length > 0
        @location = Locate.new params[:location_select] || @new_location
        add_location = @location.add @user

        if add_location[:status] == true 
          location_changed = true
        else
          location_changed = false
          @user.errors.add(:location, add_location[:message])
        end
      end             

      
      if success && @user.errors.empty?
        flash[:notice] = "Profile updated"
        redirect_to edit_user_path(@user)    
      else
      
        flash[:error] = "Could not save changes"    
        render :action => :edit
      end  

    else
      flash[:error] = "Could not save changes, incorrect password."    
      render :action => :edit
    end

    
  end


  def remove_location
    if current_user.locations.count < 2
      flash[:error] = "Cannot remove location, you must have at least one"
    else
      location = current_user.locations.find_by_location params[:location]
      if location
        flash[:notice] = "Location removed" if location.destroy
      else
        flash[:error] = "Unknown location"      
      end
    end
    
    redirect_to :back
  end



  # action to perform when the user wants to change their password
  def change_password
      return unless request.post?

    if verify_recaptcha(params)

      if User.authenticate(current_user.login, params[:old_password])
        if (params[:password] == params[:password_confirmation])
          current_user.password_confirmation = params[:password_confirmation].to_s
          current_user.password = params[:password].to_s

          current_user.reset_password

          if current_user.save
            flash[:notice] = "Password updated successfully"
            redirect_to edit_profile_url
          else
            flash[:error] = "Could not change password."
          end
        else
          flash[:error] = "New password mismatch"
            @old_password = params[:old_password]
        end
      else
        flash[:error] = "Old password incorrect"
      end

    else
      flash[:error] = "You failed the ReCAPTCHA test, try again"

    end

  end

  # action to perform when the users clicks forgot_password
  def forgot_password
    return unless request.post?

    if verify_recaptcha(params)

      if @user = User.find_by_email(params[:email])
        @user.forgot_password
        @user.save
        flash[:notice] = "A password reset link has been sent to your email address: #{params[:email]}"
        redirect_to :root
      else
        flash[:error] = "Could not find a user with that email address: #{params[:email]}"
      end
    else
      @email       = params[:email]
      flash[:error] = "You failed the ReCAPTCHA test, try again"

    end
  end

  # action to perform when the user resets the password
  def reset_password
    @user = User.find_by_password_reset_code(params[:code])
    if @user == nil
      flash[:error] = "This reset link is no longer active.  You may request a new one if you need it."
      render :action => 'forgot_password'
    end
    return if @user unless params[:user]

    if verify_recaptcha(params)
      if ((params[:user][:password] && params[:user][:password_confirmation]))
        self.current_user = @user # for the next two lines to work
        current_user.password_confirmation = params[:user][:password_confirmation]
        current_user.password = params[:user][:password]

        @user.reset_password
        current_user.password_reset_code = nil
        if current_user.save
          flash[:notice] = "Password changed."
          redirect_back_or_default('/')
        else
          flash[:error] = "Could not change password."
          @user = current_user
        end

      else
        flash[:alert] = "Password mismatch"
      end
    else
      flash[:error] = "You failed the ReCAPTCHA test, try again"
    end

  end


  def resend_activation_link
    user = User.find_by_login params[:login]
    if user
      if !user.active?
        UserMailer.deliver_signup_notification(user) 
        flash[:notice] = "Activation email resent, please check you mail (for security reasons we are not displaying the email address here). "
      else
        flash[:error] = "This account is already active."      
      end
    else
      flash[:error] = "Unknown user."
    end
    redirect_to login_path
  end


  def destroy
    @user = User.find_by_login params[:id]    
    if @user and current_user.admin?
      if @user.destroy
        flash[:notice] = "The user was deleted."
        redirect_to users_path
      else
        flash[:error] = "Something happened, could not destroy"
        render :action => :show
      end
    else
      flash[:error] = "This user does not exist, or you are not allowed to destroy it."
      redirect_to :back
    end    
  end


end
