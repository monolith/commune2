require File.dirname(__FILE__) + '/../spec_helper'

describe Reminder do

  before(:each) do
    @reminder = Reminder.new(
      :user => mock_model(User)
  )
  end

  it "should be valid" do
    @reminder.should be_valid
  end
  
  it "is not valid without user" do
    @reminder.user = nil
    @reminder.should_not be_valid
  end
  
  
  describe "#find_users_due_for_alert" do
    
      context "dashboard alert" do
      
        before(:each) do
          User.destroy_all
          5.times { create_user_with_associations! } # also creates reminder for each

          User.all.each do|user|
            user.logon.update_attribute(:last, Time.now.utc - 10.days)
            user.update_attribute(:activation_code, nil)
            user.reminder.update_attribute(:dashboard_last_sent_at, Time.now.utc - 10.days)
          end
        
        end

        it "finds only users who want to receive dashboard alerts" do
          Reminder.all.first.update_attribute(:dashboard, false)
          Reminder.all.last.update_attribute(:dashboard, false)
          
          Reminder.find_users_due_for_alert.size.should == 3          
        end


        it "finds only users who have not logged in recently" do
          User.all.first.logon.update_attribute(:previous, Time.now.utc - 3.days)
          User.all.last.logon.update_attribute(:previous, Time.now.utc - 3.days)
                    
          Reminder.find_users_due_for_alert.size.should == 3          
        end
        

        it "finds only users who have not been sent an alert recently or never sent" do
          
          User.all.first.reminder.update_attribute(:dashboard_last_sent_at, Time.now.utc - 3.days)
          User.all.last.reminder.update_attribute(:dashboard_last_sent_at, nil) # should still count... never sent
                    
          Reminder.find_users_due_for_alert.size.should == 4
          
        end

        it "returns an empty array if there are no reminders" do
          Reminder.all.each { |reminder| reminder.update_attribute(:dashboard, false) }
          users = Reminder.find_users_due_for_alert
          
          users.class.should == Array
          users.size.should == 0

        end

        it "returns an empty array when there are no users" do
          User.delete_all
          users = Reminder.find_users_due_for_alert
          
          users.class.should == Array
          users.size.should == 0
          
        end        
    
      end
 
  end
  
  describe "#users_with_reminders" do

    context "dashboard alert" do
      it "should return only users with something on their dashboard" do
      
        users = Array.new(3) {mock_model(User)}

        users[0].stub!(:dashboard_stats).and_return({:total => 0} ) # should not be returned
        users[1].stub!(:dashboard_stats).and_return({:total => 1} )
        users[2].stub!(:dashboard_stats).and_return({:total => 2} )

        Reminder.stub!(:find_users_due_for_alert).and_return(users)

        reminders = Reminder.users_with_reminders
        reminders.size.should == 2

      end
      
      it "should return nothing if no one is due for alert" do
      
        users = Array.new(2) {mock_model(User)}

        users[0].stub!(:dashboard_stats).and_return({:total => 0} ) # should not be returned
        users[1].stub!(:dashboard_stats).and_return({:total => 0} )

        Reminder.stub!(:find_users_due_for_alert).and_return(users)

        reminders = Reminder.users_with_reminders
        reminders.size.should == 0

      end
    
    end
  
  end





end
