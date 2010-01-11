class Reminder < ActiveRecord::Base
  validates_presence_of :user

  belongs_to :user

  # note users with reminders are email
  def self.users_with_reminders
    users = self.find_users_due_for_alert
    users = users.collect{ |user| user if user.dashboard_stats[:total] > 0 }.compact

    puts "Number of users: " + users.size.to_s
    return users
  end  
  
  private
  
    def self.find_users_due_for_alert
      time_ago = Time.now.utc - 7.days
      User.find :all, :joins => [:reminder, :logon], :conditions => ["reminders.dashboard = true AND users.activation_code is Null AND logons.previous < Date(?) AND (reminders.dashboard_last_sent_at < Date(?) OR reminders.dashboard_last_sent_at is Null)", time_ago, time_ago]
      
    end
    
end
