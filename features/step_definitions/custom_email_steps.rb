# Avaibale methods:
#
# reset_mailer 
# open_last_email
# visit_in_email
# unread_emails_for
# mailbox_for
# current_email
# open_email
# read_emails_for
# find_email


# FROM EMAIL SPEC HELPERS...
#
#    def visit_in_email(link_text)
#      visit(parse_email_for_link(current_email, link_text))
#    end
#    
#    def click_email_link_matching(regex, email = current_email)
#      url = links_in_email(email).detect { |link| link =~ regex }
#      raise "No link found matching #{regex.inspect} in #{email.body}" unless url
#      request_uri = URI::parse(url).request_uri
#      visit request_uri
#    end
#    
#    def click_first_link_in_email(email = current_email)
#      link = links_in_email(email).first
#      request_uri = URI::parse(link).request_uri
#      visit request_uri
#    end
#    
#    def open_email(address, opts={})
#      address = convert_address(address)
#      set_current_email(find_email!(address, opts))
#    end
#    
#    alias_method :open_email_for, :open_email

#    def open_last_email
#      set_current_email(last_email_sent)
#    end

#    def open_last_email_for(address)
#      address = convert_address(address)
#      set_current_email(mailbox_for(address).last)
#    end
#    
#    def current_email(address=nil)
#      address = convert_address(address)
#      email = address ? email_spec_hash[:current_emails][address] : email_spec_hash[:current_email]
#      raise Spec::Expectations::ExpectationNotMetError, "Expected an open email but none was found. Did you forget to call open_email?" unless email  
#      email
#    end
#    
#    def unread_emails_for(address)
#      address = convert_address(address)
#      mailbox_for(address) - read_emails_for(address)
#    end
#    
#    def read_emails_for(address)
#      address = convert_address(address)
#      email_spec_hash[:read_emails][address] ||= []
#    end
#    
#    def find_email(address, opts={})
#      address = convert_address(address)
#     if opts[:with_subject]
#        email = mailbox_for(address).find { |m| m.subject =~ Regexp.new(opts[:with_subject]) }
#      elsif opts[:with_text]
#        email = mailbox_for(address).find { |m| m.body =~ Regexp.new(opts[:with_text]) }
#      else
#        email = mailbox_for(address).first
#      end
#    end
#    
#    def links_in_email(email)
#      URI.extract(email.body, ['http', 'https'])
#    end


@email = nil
@received_with_subject = nil

def set_my_email(email_address)
  @email = email_address
end

def my_email
  @email
end

def received_with_subject
 @received_with_subject 
end

def set_received_with_subject(email)
 @received_with_subject = email
end


Given /^my email is "([^\"]*)"$/ do |email|
  set_my_email email
end


Then /^"([^\"]*)" should receive an email with "([^\"]*)" in subject$/ do |email_address, subject|
  # there are several tings happening here:
  # first, unread emails are found for given address
  # then it parses through them and collects emails matching the subject in the subject line
  # NOTE: there could be other things in the subject line, this is not an exact match
  # lastly, since nil will be returned for emails that do not match, 
  # the compact method removes the nils

  # there may be a better way of doing this
  # such as: find_email(email_address, :with_subject => subject )
  emails = unread_emails_for(email_address).collect { |e| e if e.subject =~ Regexp.new(subject) }.compact!
  emails.size.should >= 1 # Note that there can be more than one
  
  # this is done to make /^I open this email$/ work (see below)
  set_received_with_subject(emails[0]) unless emails.size == 0
end

Then /^I should receive an email with "([^\"]*)" in subject$/ do |subject|
  # logic almost same as above
  emails = unread_emails_for(current_email_address).collect { |e| e if e.subject =~ Regexp.new(subject) }.compact!
  emails.size.should >= 1 # Note that there can be more than one
  set_received_with_subject(emails[0]) unless emails.size == 0  
end

When /^(.*) opens? this email$/ do |ignore|
  set_current_email(received_with_subject)
end

Then /^(.*) should see "([^\"]*)" in this email$/ do |ignore, text|
  current_email.body.should =~ Regexp.new(text)
end

Then /^reply\-to should have "([^\"]*)"$/ do |email_address|
  current_email.header["reply\-to"].body.should == email_address
end

  

