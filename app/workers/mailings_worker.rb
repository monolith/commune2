# REMEMBER to restart workling after adding a new one
# RAILS_ENV=development script/workling_client restart
# RAILS_ENV=production script/workling_client restart

class MailingsWorker < Workling::Base

  def reminders(options)
    print "Reminding... #{Time.now.utc}\n"
    Reminder.users_with_reminders.each do |recipient|
      print ("Sending reminder to " + recipient.login.to_s + " #{ Time.now.utc }\n")
      UserMailer.deliver_dashboard_alert(recipient)
      recipient.reminder.update_attribute(:dashboard_last_sent_at, Time.now.utc)
    end
  end

  def new_job_application_notification(job_application)
    print "New job application notification... #{Time.now.utc}\n"
    UserMailer.deliver_new_job_application_notification(job_application)
  end

  def notify_applicant_of_job_offer(job_application)
    print "New job application notification... #{Time.now.utc}\n"
    UserMailer.deliver_notify_applicant_of_job_offer(job_application)
  end

  def notify_job_poster_of_accepted_offer(job_application)
    print "Accepted job offer notification... #{Time.now.utc}\n"
    UserMailer.deliver_notify_job_poster_of_accepted_offer(job_application)
  end

end

