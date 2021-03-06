class IdeasController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index
    if params[:search]
    @ideas = Idea.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
          :include => [:user, :scorecard],
          :field_weights => {
          "title"       => 3,
          "description" => 2,
      },
      :match_mode    => :extended,
      :page          => params[:page],
      :order         => "@relevance DESC, adjusted_rating DESC, active_projects_count DESC, watchers_count DESC, created_at DESC"

    else
      # activation code ensures only only ideas from activated (activation after registeration) users are shown
      @ideas = Idea.get
    end

    @ideas.compact! # removes any nil objects
  end

  def suggestions
    @suggestions = Idea.get :filter => "industries.name = 'Commune2 enhancement'", :page => params[:page]
    @idea = Idea.new # for new suggestion
    @industry = Industry.find_by_name("Commune2 enhancement")

  end

  def my_ideas
    @ideas = current_user.ideas.paginate :per_page => 10, :page => params[:page], :order => 'id DESC'
    @ideas.compact! # removes any nil objects

  end

  def new
    @idea = Idea.new
    if current_user.industry_ids.size > 0
      @industry_ids =  current_user.industry_ids # defaultbased on profile
      @message =  "defaulted based on your profile."
    else
      @industry_ids = {} # no default in this situation
      @message = ""
    end

  end


  def create

    # will need to add check if another idea with same or similar title exists
    @idea = current_user.ideas.new(params[:idea])
    @industry_ids = (params[:industry_ids] || {}).keys.collect{|s| s.to_i}

    success = Industry.update_industries :object=> @idea, :industry_ids => @industry_ids

    if success && @idea.save
      if params[:redirect] == "suggestion"
        flash[:notice] = "Thank you for your suggestion, it has been posted"
        redirect_to suggestions_path
      else
        flash[:notice] = "Your idea has been posted"
        redirect_to idea_path(:id => @idea)
      end
    else

      if params[:redirect] == "suggestion"
        flash[:error]  = "Something went wrong, we could not post your suggestion.  Try again (this time from the new idea page)."
      else
        flash[:error]  = "Your post did not go through.  Try again."
      end
      render :action => :new

    end

  end


  def edit

    @idea = Idea.find params[:id]

    unless @idea && @idea.user_id == current_user.id
        @idea = nil
        flash[:error] = "That idea does not exist or you are not allowed to edit it."
        redirect_back_or_default('/')
        return
    end

   @industry_ids = @idea.industry_ids

  end


  def update
    @idea = Idea.find params[:id]
    @industry_ids = (params[:industry_ids] || {}).keys.collect{|s| s.to_i}

    if @idea and @idea.user == current_user
      Industry.update_industries :object=> @idea, :industry_ids => @industry_ids

      if @idea.update_attributes(params[:idea])
          flash[:notice] = "Changes saved"
          redirect_to edit_idea_path(@idea)

      else
        flash[:error] = "Could not save changes"
        render :action => :edit
      end
    else
      idea = nil
      flash[:error] = "That idea does not exist or you are not allowed to edit it."
      redirect_back_or_default('/')
    end

  end

  def show
    @idea = Idea.find params[:id], :include => [:user, :scorecard, :active_projects, :interested, :industries, :comments]

    @project = @idea.projects.new

    if @idea
      if @idea.active == false && @idea.user_id != current_user.id
       flash[:error] = "This idea is no longer active, you cannot see it."
       @idea = nil
       return
      end
    end
  end

  def destroy
    @idea = Idea.find params[:id]
    if @idea and current_user.admin?
      if @idea.destroy
        flash[:notice] = "The idea was deleted."
        redirect_to ideas_path
      else
        flash[:error] = "Something happened, could not destroy"
        render :action => :show
      end
    else
      flash[:error] = "This idea does not exist, or you are not allowed to destroy it."
      redirect_to :back
    end
  end

  def add_comment
    return unless request.post?
    @idea = Idea.find(params[:idea])
    @comment = params[:newcomment]
    if @comment
      @idea.attach_comment(@comment, current_user)
      @comment = nil
      flash[:notice] = "Comment added"
    end

    redirect_to :back

  end

end

