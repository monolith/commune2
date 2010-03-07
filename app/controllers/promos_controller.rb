class PromosController < ApplicationController
  before_filter :login_required, :except => [ ]
  before_filter :admin_only

  def index
    @promos = Promo.all
  end

  def new
    @promo = Promo.new
  end

  def create
    @promo = Promo.new(params[:promo])
    if @promo.save
      flash[:notice] = "Successfully created promo"
      redirect_to promos_url
    else
      render :action => 'new'
    end
  end

  def edit
    @promo = Promo.find(params[:id])
  end

  def update
    @promo = Promo.find(params[:id])
    params[:promo][:code].strip!
    if @promo.update_attributes(params[:promo])
      flash[:notice] = "Successfully updated promo"
      redirect_to promos_url
    else
      render :action => 'edit'
    end
  end

  private

  def admin_only
    unless current_user.admin?
    flash[:error] = "Access denied"
    redirect_to root_path
    end
  end

end

