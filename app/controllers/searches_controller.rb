class SearchesController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index
    search = params[:search].nil? ? "" : params[:search].gsub("@", "\\@")
    # gsub need to get @ to work in extended mode

    # need to figure out somehow to include invitations here 
    # limiting it to only invitations sent by current_user
    @results = ThinkingSphinx::Search.search search,
      :classes => [ Idea, Project, Job, User ],
      :match_mode    => :extended,
      :order         => "@relevance DESC, watchers_count DESC, created_at DESC",
      :page          => params[:page],
      :per_page => 10
  end              

end
