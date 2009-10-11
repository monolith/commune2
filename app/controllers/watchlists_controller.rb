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
      @people = Array.new
      
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
              @people << item.watch
          end
        end
      end

    else

      @ideas = current_user.watched_ideas.compact
      @projects = current_user.watched_projects.compact
      @people = current_user.watched_people.compact
      @jobs = current_user.watched_jobs.compact

      @ideas = nil if @ideas.size == 0
      @projects = nil if @projects.size == 0
      @people  = nil if @people.size == 0
      @jobs  = nil if @jobs.size == 0
            
    end

    @title = "My Watchlist"
    @header = "Watchlist"

    @ideas_count = @ideas ? @ideas.size : 0
    @projects_count = @projects ? @projects.size : 0
    @jobs_count = @jobs ? @jobs.size : 0
    @people_count = @people ? @people.size : 0
    @count = @ideas_count + @projects_count + @jobs_count + @people_count
    
  end

  def create
    
    if params[:watchlist]
      watchlist = Watchlist.new(params[:watchlist])
    else
      # this is for doing this via link
      watchlist = Watchlist.new
      watchlist.watch_type = params[:watch_type]
      watchlist.watch_id = params[:watch_id]
    end
    
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
    @header = @title = "Ideas Watchlist"
    @ideas = current_user.watched_ideas
    @count = @ideas_count = @ideas.size
      
    render :action => :index
  end

  def projects
    @header = @title = "Projects Watchlist"
    @projects = current_user.watched_projects
    @count = @projects_count = @projects.size

    render :action => :index
 
  end

  def jobs
    @header = @title = "Jobs Watchlist"
    @jobs = current_user.watched_jobs
    @count = @jobs_count = @jobs.size
  
    render :action => :index    
  end
  
  def people
    @header = @title = "People Watchlist"
    @people = current_user.watched_people
    @count = @people_count = @people.size

    render :action => :index    
  end
  
end
