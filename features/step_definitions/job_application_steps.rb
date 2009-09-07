Given /^the following job application records?$/ do |table|

  # to delete, need to be careful not to delete the project managers
  to_destroy = JobApplication.find :all, :include => [:project], :conditions => ["job_applications.user_id != projects.user_id"]
  to_destroy.each { |a| a.destroy } # not very efficient but will do for now
  
  table.hashes.each do |attributes|
  
    application = attributes.dup
    
    if attributes[:applicant] 
      applicant = { :login => attributes[:applicant] } 
      application.delete("applicant") if attributes[:applicant]
    end    

    if attributes[:job]
      job = { :title => attributes[:job] }
      application.delete("job")
    end
    
    if attributes[:project]
      project = { :title => attributes[:project] }
      application.delete("project")
    end

    create_job_application!( { :applicant => applicant, :job => job, :project => project, :application => application  } )
  end

end
