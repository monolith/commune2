class UserMailer < ActionMailer::Base
  def dashboard_alert(user)
    setup_email(user)
    @subject    += 'Dashboard reminder'

  end

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{domain}/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.commune2.com/"
  end

  def forgot_password(user)
    setup_email(user)

    @subject    += 'Password reset help'
    @body[:url]  = "http://#{domain}/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    setup_email(user,'Your password has been reset.')
  end

  def general(options = {})

      @recipients  = options[:recipients]
      @from        = options[:from] || postman
      @reply_to    = options[:reply_to] if options[:reply_to]

      @subject     = options[:subject] || "Commune2.com email"
      @sent_on     = Time.now
      @bcc = postman

      @body[:who] = options[:who] || @reply_to
      @body[:message] = options[:message]
      @body[:url]  = options[:url] || "http://www.commune2.com/"

  end


  def message(msg)
    who = msg.from.name.blank? ? msg.from.login : msg.from.name
    @recipients       = msg.to.email
    @from             = postman
    @reply_to         = msg.from.email
    @subject          = "[commune2 | " + who + "] " + msg.subject
    @sent_on          = Time.now
    @bcc              = @from

    @body[:message]   = msg.body
    @body[:who]       = who
    @body[:profile]   = msg.from

  end

  def new_job_application_notification(job_application)
    @recipients = job_application.job.user.email
    @from       = postman
    @subject    = "[commune2] New applicant for #{ job_application.job.title }"
    @sent_on    = Time.now.utc

    @body[:job_application] = job_application
    @body[:domain]  = domain
  end

  def notify_applicant_of_job_offer(job_application)

    @recipients = job_application.user.email
    @from       = postman
    @subject    = "[commune2] Job Offer for #{ job_application.job.title }"
    @sent_on    = Time.now.utc

    @body[:job_application] = job_application
    @body[:domain]  = domain
  end

  def notify_job_poster_of_accepted_offer(job_application)

    @recipients = job_application.job.user.email
    @from       = postman
    @subject    = "[commune2] Job Offer Accepted for #{ job_application.job.title }"
    @sent_on    = Time.now.utc

    @body[:job_application] = job_application
    @body[:domain]  = domain
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = postman
      @subject     = "[commune2.com] "
      @sent_on     = Time.now
      @bcc = @from

      @body[:user] = user
    end

private

  def domain
    ENV['RAILS_ENV'] == "production" ? "commune2.com" : "commune2.local"
  end

  def postman
    ENV['RAILS_ENV'] == "production" ? "Commune2 Postman <postman@mailer.commune2.com>" : "C2 DEV Postman <devpost@mailer.commune2.com>"
  end

end

