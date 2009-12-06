require File.dirname(__FILE__) + '/../spec_helper'

describe MailingsWorker do

  describe "#reminders" do    
    context "dashboard alert" do
      before(:each) do
        User.destroy_all
        3.times { create_user_with_associations! }
        User.all.each { |user| user.reminder.update_attribute(:dashboard_last_sent_at, nil) }
        
        # set all mailboxes to empty
        ActionMailer::Base.deliveries = []
        Reminder.stub!(:users_with_reminders).and_return(User.find :all)

      end

      it "should email all with a reminder" do        
        MailingsWorker.async_reminders
        ActionMailer::Base.deliveries.size.should == 3
      end

      it "should send an email to each user with a reminder" do
        Reminder.users_with_reminders.each do |user|
          UserMailer.should_receive(:deliver_dashboard_alert).with(user)
        end
        MailingsWorker.async_reminders
      end
      
      it "should update last sent time after sending the email" do
        MailingsWorker.async_reminders
        Reminder.users_with_reminders.each do |user| # remember that users with reminders is stubbed, which is why it will still return these users
          user.reminder[:dashboard_last_sent_at].should be_close(Time.now.utc, 5.minutes) # 5 minutes just an arbitrary number here
        end               
      end
 
    end
  
  end
    
end
