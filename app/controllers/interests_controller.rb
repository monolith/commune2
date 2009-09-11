class InterestsController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index

    if params[:search]
      interests = current_user.interests.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
        :include       => [:interest ],
        :match_mode    => :extended,
        :order         => "@relevance DESC, created_at DESC" 
    
      @ideas = Array.new
      @projects = Array.new
      
      interests.each do |item|      
        unless item.interest.nil?
          case item.interest.class.to_s
            when "Idea"
              @ideas << item.interest
            when "Project"
              @projects << item.interest                 
          end
        end
      end
    else
    
      @ideas = current_user.interested_ideas.compact
      @projects = current_user.interested_projects.compact

    end              

    @title = "What you have expressed interest in"
    @header = "Interested"

    @ideas_count = @ideas.size
    @projects_count = @projects.size
    @count = @ideas_count + @projects_count

    render :template => 'watchlists/index'
  
  end

  def create
    interest = Interest.new(params[:interest])
    interest.user = current_user

    if interest.save
      # also add to wathlist
      unless interest.interest.watchers.include? current_user
        watchlist = current_user.watchlists.new :watch_id => interest.interest_id, :watch_type => interest.interest_type
        watchlist.save
      end
      flash[:notice] = "Thank you for showing interest, this has also been added to your watchlist"
    else
      flash[:error]  = "That didn't work.  Try again."
    end      
    redirect_to :back

  end

  def destroy

    interest = Interest.find(params[:id])
    if interest.user == current_user
      interest.destroy
      flash[:notice] = "You are no longer showing interest."
    else
      flash[:error] = "Sorry, that didn't work"
    end
    
    redirect_to :back
    
  end


  def ideas
    @title = "Ideas where you have shown interest"
    @header = "Idea Interests"
    @ideas = current_user.interested_ideas
    @count = @ideas_count = @ideas.count

    render :template => 'watchlists/index'
  end

  def projects
    @title = "Projects where you have shown interest"
    @header = "Project Interests"
    @projects = current_user.interested_projects
    @count = @projects_count = @projects.count

    render :template => 'watchlists/index'
  end

end
