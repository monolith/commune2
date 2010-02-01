class JobsController < ApplicationController
  # TODO: add job feed for http://www.allforgood.org, http://www.simplyhired.com, http://www.hound.com,

  before_filter :login_required, :except => [:indeed_feed, :public_preview]

  def index

    if params[:search]
      @jobs = Job.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
        :include => [:user, :project],
        :field_weights => {
            "title"       => 25,
            "description" => 15,
            "location" => 2,
        },
        :match_mode    => :extended,
        :page          => params[:page],
        :order         => "@relevance DESC, created_at DESC"
    else
      if params[:project_id] # check if this was launched from an idea
        @project = Project.find params[:project_id]
        @jobs = Job.get(['project_id = ? and active and open', @project.id], 'id DESC', params[:page])
      else
        @jobs = Job.get('active and open', 'id DESC', params[:page])
      end
    end

    @title = "JOBS"

  end


  def show
    @job = Job.find params[:id], :include => [:user, :project, :general_skills]

    if @job.applicants.include? current_user
      @application = @job.user_application current_user
    else
      @application = @job.job_applications.new
    end

      if @job.active == false && @job.user_id != current_user.id
        flash[:error] = "This job post is no longer active, you cannot see it"
        @job = nil
      end
  end


  def new
    if params[:project_id]
       @project = Project.find(params[:project_id])
       if @project and (@project.members.include? current_user or @project.user == current_user)
         @job = @project.jobs.new
         @skill_ids = {}

       else
          flash[:error] = "Could not post job because the project does not exist or you are not on the project team"
          redirect_back_or_default('/')
       end
    else
      flash[:notice] = "A job must be posted from a project"
      flash[:new_job] = true
      redirect_to my_projects_path
    end
  end


  def create
    # TODO: will need to add check if another idea with same or similar title exists
    @job = current_user.jobs.new(params[:job])
    @project = @job.project

    unless @project.members.include? current_user
      # current user must be a project member in order to create a project
      flash[:error] = "You are not a member of this project, cannot create job."
      redirect_back_or_default('/')
      return
    end
    @skill_ids = (params[:skill_ids] || {}).keys.collect{|s| s.to_i}



    # add poster as project manager
    if GeneralSkill.update_general_skills(:object=> @job, :skill_ids => @skill_ids) && @job.save
      flash[:notice] = "This job has been posted"
      redirect_to job_path(:id => @job)
    else
      flash[:error]  = "Your post did not go through.  Try again."
      render :action => 'new'
    end

  end


  def edit
    @job = Job.find params[:id]
    unless @job and @job.project.members.include? current_user
      @job = nil
      flash[:error] = "That job does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
      return
    end
    @skill_ids = @job.general_skill_ids

  end


  def update

    # should not be able to update project
    # if later supported, should verify that current user is a project member of both
    params.delete("project_id")

    @job = Job.find params[:id]
    @skill_ids = (params[:skill_ids] || {}).keys.collect{|s| s.to_i}

    if @job and @job.project.members.include? current_user

      @job.attributes = params[:job]
      if GeneralSkill.update_general_skills(:object=> @job, :skill_ids => @skill_ids) && @job.save
        flash[:notice] = "Changes saved"
        redirect_to edit_job_path(:id=>@job)
      else
        flash[:error] = "Could not save changes"
        render :action => :edit
      end

    else
      @job = nil
      flash[:error] = "That project does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
    end

  end



  def my_jobs
    if current_user.scorecard.active_jobs_count > 0
      redirect_to open_job_postings_path
    else
      redirect_to open_applied_for_jobs_path
    end

  end

  def open_job_postings
    @jobs = current_user.open_job_postings.paginate :per_page => 10, :page => params[:page], :order => "jobs.id DESC",
                                       :include => [:user, :project]

    @title = "My Open Job Postings"
    render :action => 'index'
  end

  def job_posting_history
    @jobs = current_user.job_posting_history.paginate :per_page => 10, :page => params[:page], :order => "jobs.id DESC",
                                       :include => [:user, :project, :hired_user]
    @title = "My Job Post History"
    render :action => 'index'
  end


  def open_applied_for_jobs
    @jobs = current_user.open_applied_for_jobs.paginate :per_page => 10, :page => params[:page], :order => "jobs.id DESC",
                                       :include => [:user, :project]

    @title = "My Applied for Open Jobs"
    render :action => 'index'
  end


  def applied_for_job_history
    @jobs = current_user.applied_for_history.paginate :per_page => 10, :page => params[:page], :order => "jobs.id DESC",
                                       :include => [:user, :project]

    @title = "My Applied for Job History"
    render :action => 'index'
  end


  def current_positions
    @jobs = current_user.current_jobs.paginate :per_page => 10, :page => params[:page], :order => "job_applications.id DESC"

    @title = "My Hired Positions (includes inactive)"
    render :action => 'index'
  end

  def active_current_positions
    @jobs = current_user.active_current_jobs.paginate :per_page => 10, :page => params[:page], :order => "job_applications.id DESC"

    @title = "My Active Positions"
    render :action => 'index'
  end


    def destroy
    @job = Job.find params[:id]
    if @job and current_user.admin?
      if @job.destroy
        flash[:notice] = "The job was deleted."
        redirect_to jobs_path
      else
        flash[:error] = "Something happened, could not destroy"
        render :action => :show
      end
    else
      flash[:error] = "This job does not exist, or you are not allowed to destroy it."
      redirect_to :back
    end
  end


  def indeed_feed
    @jobs = Job.find :all, :conditions => ["jobs.open and jobs.active and jobs.external_publish_ok"], :include => [:user, {:user => :locations}]

    respond_to do |format|
      format.xml
    end

  end


  def public_preview
    @job = Job.find params[:id], :include => [:project, :user, {:user => :locations}]

    if logged_in?
      redirect_to job_path(@job)
    else
      unless @job and @job.status == "Open" and @job.external_publish_ok
        @job = nil
        redirect_to root_path
        flash[:notice] = "Sorry, looks like the job you were looking for is not available"

      end
    end

  end

end

