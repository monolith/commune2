class WatchlistsController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index

    if params[:search]
      watchlist = current_user.watchlists.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
        :include       => [:watch ],
        :match_mode    => :extended,
        :order         => "@relevance DESC, created_at DESC" 
    
      @ideas = Array.new
      @projects = Array.new
      @jobs = Array.new
      @profiles = Array.new
      
      watchlist.each do |item|
      
        unless item.watch.nil?
          case item.watch.class.to_s
            when "Idea"
              @ideas << item.watch
            when "Project"
              @projects << item.watch                 
            when "Job"
              @jobs << item.watch
            when "User"
              @profiles << item.watch
          end
        end
      end

    else

      @ideas = current_user.watching_ideas.compact
      @projects = current_user.watching_projects.compact
      @profiles = current_user.watching_users.compact
      @jobs = current_user.watching_jobs.compact
            
    end

    @title = "What you are watching"
    @header = "Watchlist"

    @ideas_count = @ideas.size
    @projects_count = @projects.size
    @jobs_count = @jobs.size
    @profiles_count = @profiles.size
    @count = @ideas_count + @projects_count + @jobs_count + @profiles_count
    
  end

  def create
    watchlist = Watchlist.new(params[:watchlist])
    watchlist.user = current_user

    if watchlist.save
      flash[:notice] = "Added to watchlist"
    else
      flash[:error]  = "Could not add to watchlist.  Try again."
    end      
    redirect_to :back

  end

  def destroy

    watchlist = Watchlist.find(params[:id])
    if watchlist.user == current_user
      watchlist.destroy
      flash[:notice] = "Removed from watchlist"
    else
      flash[:error] = "You cannot affect someone else's watchlist"
    end
    
    redirect_to :back
    
  end

  def ideas
    @title = "Ideas you are watching"
    @header = "Ideas Watchlist"
    @ideas = current_user.watched_ideas
    @count = @ideas_count = @ideas.size
      
    render :action => :index
  end

  def projects
    @title = "Projects you are watching"
    @header = "Projects Watchlist"
    @projects = current_user.watched_projects
    @count = @projects_count = @projects.size

    render :action => :index
 
  end

  def jobs
    @title = "Jobs you are watching"
    @header = "Jobs Watchlist"
    @jobs = current_user.watched_jobs
    @count = @jobs_count = @jobs.size
  
    render :action => :index    
  end
  
  def profiles
    @title = "Profiles you are watching"
    @header = "Profiles Watchlist"
    @profiles = current_user.watched_people
    @count = @profiles_count = @profiles.size

    render :action => :index    
  end
  
end
