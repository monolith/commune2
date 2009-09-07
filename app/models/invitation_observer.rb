class InvitationObserver < ActiveRecord::Observer
  def after_save(invitation) # after save to make sure that this also picks up resend
    # probably should add this to some message queue instead of sending email each time
    reply = invitation.user.email
    from = "Commune2 on behalf of " << reply << " <postmaster@mailer.commune2.com>"
    subject = "Invitation to join Commune2"
    UserMailer.deliver_general(:recipients => invitation.email, :from => from, :reply_to => reply, :subject => subject, :message => invitation.message)

  end

end
