class MessagesController < ApplicationController
  before_filter :login_required, :update_login_time, :except => [ ]

  def new
    @user = User.find_by_login params[:user_id]
    if @user && @user.active
      @message = @user.received_messages.new
    else
      flash[:error] = params[:user_id] + " does not exist or is inactive."
      redirect_to users_path
    end

  end

  def create

    @message = current_user.sent_messages.new(params[:message])
    @user = @message.to

    if verify_recaptcha(params)

      if @message && @message.save
        flash[:notice] = "Message sent."
        redirect_to user_path(@message.to)
      else
        flash[:error] = "Failed to send message."
        render :action => :new
      end
    else
      flash[:error] = "You failed the ReCAPTCHA test, try again"
      render :action => :new

    end
  end

end
