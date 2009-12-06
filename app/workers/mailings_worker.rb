
class MailingsWorker < Workling::Base
  def reminders(options)
    print "Reminding..."
    Reminder.users_with_reminders.each do |recipient|
      print ("Sending reminder to " + recipient.login.to_s + "\n")
      UserMailer.deliver_dashboard_alert(recipient)
      recipient.reminder.update_attribute(:dashboard_last_sent_at, Time.now.utc)    
    end
  end
  
end
