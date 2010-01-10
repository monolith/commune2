class InvitationObserver < ActiveRecord::Observer
  
  
  def after_create(invitation)
    # probably should add this to some message queue instead of sending email each time    
    UserMailer.deliver_general(message_for(invitation))

  end

  def after_save(invitation)
    # probably should add this to some message queue instead of sending email each time
    
    # check if resend has been requested
    if invitation.resend_requested
      success = UserMailer.deliver_general(message_for(invitation))
    
      if success
        # turn of resent request since this just resent it
        # update resent time
        invitation.resend_requested = false
        invitation.resent_at = Time.now.utc
        invitation.save(false)
      end
    end

  end


private

  def message_for(invitation)
    reply = invitation.user.email
    from = "Commune2 on behalf of " << reply << " <postmaster@mailer.commune2.com>"
    subject = "Invitation to join Commune2"


      return {  :recipients => invitation.email,
                :from => from,
                :reply_to => reply,
                :subject => subject,
                :message => invitation.message,
                :url => "http://www.commune2.com/signup?email=#{invitation.email}"}
  end

end
