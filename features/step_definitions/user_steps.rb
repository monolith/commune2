Given /^the following user records?$/ do |table|
  User.destroy_all
  parse_table_and_add_users(table)
end

Given /^the following additional user records?$/ do |table|
  # only difference between this and the above is the no destroy_all
  # these are additional users, so does not delete existing
  parse_table_and_add_users(table)
end


Then /^a user with "([^\"]*)" login should not exist$/ do |login|
  User.find_by_login(login).should equal(nil)
end




def parse_table_and_add_users(table)
  table.hashes.each do |attributes|

   # this may or may not be there.. will be used at the bottom
    last_logon = attributes[:last_logon] # will be used below

    user = attributes.dup
    user.delete("last_logon") # since this is not part of the model

    user = create_user_with_associations!( :user => user )
    # activate account.... also makes profile active
    visit activate_path(:activation_code => user.activation_code)
    
    # check if the user should be inactive per table instruction
    # this is needed because upon activation, everyone becomes active
    # see User#activate!    
    if attributes[:active] == "false"
      user.reload # reload needed otherwise not saved
      # user record here is not in sync with the db if not reloaded
      user.active = false # sets this to false as instructed by the table
      user.save(false)
    end
    
    if last_logon 
      user.logon.last = last_logon.to_time
      user.logon.previous = last_logon.to_time
      user.logon.save(false)
    end

  end  
end



Given /^there are no users$/ do
  User.destroy_all
end

Given /^there are no invitations$/ do
  Invitation.delete_all
end

When /^I activate the (.+) account$/ do |login|
  code = User.find_by_login(login).activation_code
  visit activate_path(:activation_code => code)
end

Given /^there are one or more users$/ do
  random = rand(3) + 1
  # creates anywhere fro 1-3 users
  random.times do
    create_user_with_associations!
  end
end

Given /^there is an invitation for "([^\"]*)"$/ do |email|
  Invitation.make(:email => email)
end

Given /^there is no invitation for "([^\"]*)"$/ do |email|
  Invitation.delete_all ["email = ?", email]
end

Given /^I have an account with login "([^\"]*)" and password "([^\"]*)"$/ do |login, password|
  create_user_with_associations!(:user => { :login => login })
end

Given /^the account with login "([^\"]*)" is not activated$/ do |login|
  user = User.find_by_login login
  user.active?.should == false
end

When /^I visit the activation link for "([^\"]*)"$/ do |login|
  user = User.find_by_login login
  visit activate_path(:activation_code => user.activation_code)
end


Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  visit logout_path
  
  unless login.blank?
    visit login_url
    fill_in "login", :with => login
    fill_in "password", :with => password
    click_button "Log in"
    response.should contain("logged in")
  end
end

Given /^I am logged in as "([^\"]*)"$/ do |login|
  visit logout_path

  unless login.blank?
    visit login_url
    fill_in "login", :with => login
    fill_in "password", :with => "secret"
    click_button "Log in"
    response.should contain("logged in")
  end
end


When /^I visit profile for "([^\"]*)"$/ do |login|
  user = User.find_by_login!(login)
  visit user_url(user)
end

When /^I visit edit user page ([^\"]*)$/ do |user|
  visit edit_user_url(user)
end

Given /^I am logged out$/ do
  visit logout_path
end

def current_user
  User.find session[:user_id].to_i
end


Then /^my login should be "([^\"]*)"$/ do |login|
  current_user.login.should == login
end

