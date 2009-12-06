Given /^the following reminder records?$/ do |table|
  Project.destroy_all
  table.hashes.each do |attributes|
    reminder = attributes.dup
    
    if attributes[:login] 
      user = { :login => attributes[:login] } 
      reminder.delete("login") if attributes[:login]
    end    

    if attributes[:previous_logon] 
      logon = { :previous => attributes[:previous_logon] } 
      reminder.delete("previous_logon") if attributes[:previous_logon]
    end    

    if attributes[:dashboard_last_sent_at] and attributes[:dashboard_last_sent_at].capitalize == "Now"
      reminder[:dashboard_last_sent_at] = Time.now.utc 
    end    

    # check if user was already created
    # when user is created, reminder model is also created
    # so if user was created, then the reminder also exists - in which case we just need to update it
    
    existing_user = User.find_by_login(user[:login]) if user[:login]

    if existing_user 
      # user and reminder exist
      existing_user.reminder.update_attributes(reminder)
      existing_user.logon.update_attributes(logon)
    else        
      create_reminder_with_user!( { :reminder => reminder, :user => user, :logon => logon } )
    end

  end
end

When /^reminders are sent$/ do
  MailingsWorker.async_reminders
end


Then /^(.*) should be on the reminder list$/ do |login|
  user = User.find_by_login(login)
  Reminder.users_with_reminders.should include(user)
end

Then /^(.*) should not be on the reminder list$/ do |login|
  user = User.find_by_login(login)
  Reminder.users_with_reminders.should_not include(user)
end


Then /^"([^\"]*)'s" dashboard reminder should be off$/ do |login|
  User.find_by_login(login).reminder.dashboard.should == false
end

Then /^"([^\"]*)'s" dashboard reminder should be on$/ do |login|
  User.find_by_login(login).reminder.dashboard.should == true
end

Then /^there should be no more users with pending reminders$/ do
  Reminder.users_with_reminders.size.should == 0
end

