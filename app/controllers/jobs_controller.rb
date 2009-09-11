class JobsController < ApplicationController
  before_filter :login_required, :except => [ ]

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
  end


  def show
    @job = Job.find params[:id], :include => [:user, :project, :general_skills]
    
    if @job.applicants.include? current_user
      @application = @job.user_application current_user
    else
      @application = @job.job_applications.new
    end
    
      if @job.active == false && @job.user_id != current_user.id
        flash[:error] = "This job post is no longer active, you cannot see it."
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
          flash[:error] = "The project either does not exist or you are not on the project team"
          redirect_back_or_default('/')
       end
    else
      flash[:error] = "A job must be attached to a project.  Please go to the project page and post a job from there."
      redirect_back_or_default('/')
    end    
  end

  
  def create
    # will need to add check if another idea with same or similar title exists
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

  def my_posted_jobs
    @jobs = current_user.jobs.paginate :per_page => 10, :page => params[:page], :order => "id DESC",
                                       :include => [:user, :project]

    @title = "My Posted Jobs"
  end

  def my_job_applications
    @jobs = current_user.jobs_applied.paginate :per_page => 10, :page => params[:page], :order => "job_applications.id DESC",
          :include => [:user, :project]

    @title = "My Job Applications"
    render :action => 'my_posted_jobs'
  end

end
