class InvitationsController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def index

    if params[:search]
    @invitations = current_user.invitations.search params[:search].gsub("@", "\\@"), # need to get @ to work in extended mode
      :include       => :user,
      :match_mode    => :extended,
      :page          => params[:page],
      :order         => "@relevance DESC, created_at DESC" 

    else
      @invitations = current_user.invitations.paginate :per_page => 10, :page => params[:page], :order => 'id DESC',
                                                       :include => :registered
    end

  end

  def new
    @invitation = Invitation.new
    @invitation.message = "Hey, this is a new social network gearing up for launch.  Membership is by invitation only... join while you can (I did).  And I just invited you!\n\n" + current_user.name + " (" + current_user.email + ")"
    
  end


  def create
    @invitation = current_user.invitations.new(params[:invitation])
     success = @invitation && @invitation.save
     if success && @invitation.errors.empty?
       flash[:notice] = "Invitation has been sent to " + @invitation.email + ".  Thank you."
       redirect_to new_invitation_path
     else
       flash[:error]  = "Invitation failed."
        render :action => 'new'
     end
  end
  
  def resend
    @invitation = Invitation.find params[:id]
    if @invitation.user == current_user
      @invitation.update_attribute :updated_at, Time.now.utc
      flash[:notice] = "Invitation resent to " + @invitation.email
    else
      flash[:error] = "Cannot resend.  This person either already registered or this is not your invitation."
    end
    redirect_to invitations_path
  end

end
