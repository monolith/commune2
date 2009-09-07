class CommentsController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index
    if params[:idea_id]
      @object = Idea.find params[:idea_id]
    elsif params[:project_id]
      @object = Project.find params[:idea_id]    
    elsif params[:project_id]
      @object = User.find params[:idea_id]
    end
    
    if @object
      @comments = @object.comments.paginate :per_page => 20, :page => params[:page], :order => "id DESC"
    end
  end
  
  def destroy
    @comment = Comment.find params[:id], :include => [:user, :commentable]
    @object = @comment.commentable
    if @comment and current_user.admin?
      if @comment.destroy
        flash[:notice] = "The comment was deleted."
        redirect_to polymorphic_path(@object)
      else
        flash[:error] = "Something happened, could not destroy"
        redirect_to polymorphic_path(@object)
      end
    else
      flash[:error] = "This comment does not exist, or you are not allowed to destroy it."
      redirect_to :back
    end    
  end
  
end
