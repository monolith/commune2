Given /^the following invitation records?$/ do |table|
  Invitation.destroy_all
  table.hashes.each do |attributes|
    
    if attributes[:invitee]
      att = attributes.dup
      att.delete("invitee")
      user = User.find_by_login attributes[:invitee]
      user.invitations.make(att)
    else
      Invitation.make(attributes)
    end

  end
end


Given /^there are no invitations in the system$/ do
  Invitation.destroy_all
end

