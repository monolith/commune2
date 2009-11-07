class IcebreakersController < ApplicationController
  before_filter :login_required, :except => [ ]
  before_filter :admin_only

  def index    
    @icebreakers = Icebreaker.all
  end
  
  def show
    @icebreaker = Icebreaker.find(params[:id])
  end
  
  def new
    @icebreaker = Icebreaker.new
  end
  
  def create
    @icebreaker = current_user.icebreakers.new(params[:icebreaker])
    if @icebreaker.save
      flash[:notice] = "Successfully created icebreaker."
      redirect_to icebreakers_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @icebreaker = Icebreaker.find(params[:id])
  end
  
  def update
    @icebreaker = Icebreaker.find(params[:id])
    if @icebreaker.update_attributes(params[:icebreaker])
      flash[:notice] = "Successfully updated icebreaker."
      redirect_to @icebreaker
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @icebreaker = Icebreaker.find(params[:id])
    @icebreaker.destroy
    flash[:notice] = "Successfully destroyed icebreaker."
    redirect_to icebreakers_url
  end
  
  
  private
  
  def admin_only
    unless current_user.admin?
    flash[:error] = "Access denied"
    redirect_to root_path
    end
  end
  
end
