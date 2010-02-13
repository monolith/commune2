Given /^the following job records?$/ do |table|

  Job.destroy_all("title != 'Project Manager'") # does not destroy the auto generated project manager
  # project manager needs to remain in order for the project to have members that can act on other jobs

  table.hashes.each do |attributes|
    job = attributes.dup

    if attributes[:author]
      author = { :login => attributes[:author] }
      job.delete("author") if attributes[:author]
    end

    if attributes[:project]
      project = { :title => attributes[:project] }
      job.delete("project")
    end

    create_job_with_skills!( { :project => project, :author => author, :job => job } )
  end

end

When /^I offer the "([^\"]*)" job to "([^\"]*)"$/ do |job, person|
  job = current_user.jobs.find_by_title job
  person = User.find_by_login person
  application = job.job_applications.find_by_user_id person.id

  application.update_attribute :offered, true
end

