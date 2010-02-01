class JobApplicationsController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

#  don't need index yet, as a partial will be used to display
#  def index
#  end

#  don't need index yet, as a partial will be used to display
#  def show
#  end

#  New will be launched from another page (from the job show page), so no need here
#  def new
#  end

#  Edit will be launched from another page (from the job show page), so no need here

#  def edit
#  end

  def create

  # TODO: email job poster a notification when someone applies

    @application = JobApplication.new params[:job_application]

    if current_user.active
      @application.user = current_user
      @application.project = @application.job.project

      if @application.save
        flash[:notice] = "You have applied for this job"
       else
        flash[:error]  = "There was an error processing your job application.  Try again."
      end
    else
        flash[:error]  = "You cannot apply when your profile is inactive, please update your profile first."
    end

    @job = @application.job

    redirect_to job_path(@job)

  end

  def update

    @application = JobApplication.find params[:id]

    if @application
      if params[:job_application][:offered]
        # offer made or withdrawn, check if the user has permission to do this
        unless @application.allowed_to_offer_job? current_user
          # this also checks to make sure hired status is not modified when offer is made
          @application.errors.add(:access, " denied, you do not have permission to change offer status.")
        end

        if params[:job_application][:offered] == "true"
          success_message = "Offer made to " + @application.user.login
        else
          success_message = "Offer withdrawn."
        end
        if params[:job_application][:hired]
          # this also checks to make sure hired status is not modified when offer is made
          @application.errors.add(:access, " denied, you cannot update hired status while making an offer.")
        end
      elsif params[:job_application][:hired]
        # either accepting job, quiting, or being fired
        if params[:job_application][:hired] == "true"
          # user is accepting job
          unless @application.allowed_to_accept_job? current_user
          @application.errors.add(:access, " denied, you do not have permission to accept this job.")
          end
         success_message = "You are now hired for this position."

        else
          # user is quiting or being fired
          unless @application.allowed_to_fire_or_quit? current_user
            @application.errors.add(:access, " denied, you do not have permission to fire this person.")
          end

          if current_user == @application.user
            success_message = "You have left this position"
          else
            success_message = "You have removed " + @application.user.login + " from this position"
          end
        end

      else
        # regular application update, such as updating message
        # should be allowed only by the user who created the applicaion
        unless @application.allowed_to_update_application? current_user
          @application.errors.add(:access, " denied, to update this application")
        end
        success_message = "Updates saved"

      end

      # make the updates
      if @application.errors.empty? and @application.update_attributes params[:job_application]
        flash[:notice] = success_message
      else
        flash[:error] = "Could not save changes"
      end

      redirect_to :back

    else
      flash[:error] = "That job application does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
    end


  end

  def destroy
    @application = JobApplication.find(params[:id])
    @job = @application.job
    if @application.user == current_user
      @application.destroy
      flash[:notice] = "Job application deleted"
      redirect_to job_path(@job)

    else
      flash[:error] = "You cannot delete this application"
      redirect_back_or_default('/')
    end

  end

end

