
class ProjectsController < ApplicationController
  require 'RedCloth'

  before_filter :login_required, :update_login_time, :except => [ ]

  # need to implement rescues, especially for when nothing is found

  def index
    if params[:search]
      @projects = Project.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
        :include       => [:user, :scorecard ],
        :field_weights => {
            "title"       => 3,
            "description" => 2,
        },
        :match_mode    => :extended,
        :page          => params[:page],
        :order         => "@relevance DESC, adjusted_rating DESC, watchers_count DESC, interested_count DESC, created_at DESC" 
    else
      if params[:idea_id] # check if this was launched from an idea
        @idea = Idea.find params[:idea_id]
        @projects = Project.get(['idea_id = ? and active', @idea.id], 'id DESC', params[:page])
      else
        @projects = Project.get('active', 'id DESC', params[:page])
      end
    end

    @projects.compact! # removes any nil objects  

  end

  def my_projects
    @projects = current_user.all_projects.paginate :per_page => 10, :page => params[:page], :order => 'id DESC'
    @projects.compact! # removes any nil objects  

  end

  def new
    if params[:idea_id] # check if this was launched from an idea
       @idea = Idea.find(params[:idea_id])
       @project = @idea.projects.new
       @industry_ids = @idea.industry_ids # default based on idea
       @message = "defaulted based on the original idea."

    else
      @project = Project.new
      if current_user.industry_ids.size > 0
        @industry_ids =  current_user.industry_ids # defaultbased on profile
        @message =  "defaulted based on your profile."
      else
        @industry_ids = {} # no default in this situation
        @message = ""
      end
    end
    
  end

  def create
  
      # will need to add check if another idea with same or similar title exists
      @project = current_user.projects.new(params[:project])
      @idea = @project.idea
      @industry_ids = (params[:industry_ids] || {}).keys.collect{|s| s.to_i}
      
      Industry.update_industries(:object=> @project, :industry_ids => @industry_ids)
      
      success = @project and @project.save
      if success && @project.errors.empty?
        flash[:notice] = "This project has been posted"
        redirect_to project_path(:id => @project)
      else
        flash[:error]  = "Your post did not go through.  Try again."
        render :action => 'new'
      end      
  end

  def show
    @project = Project.find params[:id],
      :include => [:scorecard, :user, :idea, :open_jobs, :comments, :industries, :members, :interested ]

    @wiki = RedCloth.new(@project.wiki || "") if @project
    
    @job = @project.jobs.new         
      if not(@project.members.include? current_user) and @project.active == false 
         flash[:error] = "This project is no longer active, you cannot see it."
         @project = nil
      end
  end

  def add_comment
    return unless request.post?

    @project = Project.find(params[:project])
    @comment = params[:newcomment]

    if @comment
      @project.attach_comment(@comment, current_user)
      @comment = nil
      flash[:notice] = "Comment added"
    end
    redirect_to :back
  end

  def edit
    @project = Project.find params[:id]
    unless @project && @project.members.include?(current_user)
      @idea = nil
      flash[:error] = "That project does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
      return
    end

    @industry_ids = @project.industry_ids
 
  end

  def update

    @project = Project.find params[:id]
    @industry_ids = (params[:industry_ids] || {}).keys.collect{|s| s.to_i}

    if @project and @project.members.include?(current_user)

      @project.attributes = params[:project]
      if Industry.update_industries(:object=> @project, :industry_ids => @industry_ids) && @project.save
        flash[:notice] = "Changes saved"
        redirect_to edit_project_path(:id=>@project)
      else
        flash[:error] = "Could not save changes"
        render :action => :edit
      end
            
    else
      @project = nil
      flash[:error] = "That project does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
    end      

  end

  def destroy
    @project = Project.find params[:id]    
    if @project and current_user.admin?
      if @project.destroy
        flash[:notice] = "The project was deleted."
        redirect_to projects_path
      else
        flash[:error] = "Something happened, could not destroy"
        render :action => :show
      end
    else
      flash[:error] = "This project does not exist, or you are not allowed to destroy it."
      redirect_to :back
    end    
  end


end
