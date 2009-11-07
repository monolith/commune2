module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
      
    when /the registration page/
      new_user_path

    when /the login page/
      login_path

    when /the forgot password page/
      forgot_password_path

    when /redirected to login page/
      new_session_path
    
    when /^"(.*)'s" profile$/
      user_path($1)

    when /^"(.*)'s" edit page$/
      edit_user_path($1)

    when /my ideas page/
      my_ideas_path

    when /my watchlist/
      watchlists_path

    when /my interested list/
      interests_path

    when /ideas page/
      ideas_path
      
    when /projects page/
      projects_path

    when /jobs page/
      jobs_path

    when /profiles page/
      users_path

    when /invitations page/
      invitations_path

    when /icebreakers page/
      icebreakers_path

    when /new idea page/
      new_idea_path
  
    when /new project page/
      new_project_path

    when /new job page/
      new_job_path

    when /new invitation page/
      new_invitation_path
  
    when /view "(.*)" idea/
      idea = Idea.find_by_title $1
      idea_path(idea)


    when /view "(.*)" project/
      project = Project.find_by_title $1
      project_path(project)


    when /view "([^\"]*)" job$/
      job = Job.find_by_title $1
      job_path(job)


    when /new job for "(.*)" project$/
      project = Project.find_by_title $1
      new_job_path(:project_id => project.id)
    
    when /edit "(.*)" idea$/
      idea = Idea.find_by_title $1
      edit_idea_path(idea)

    when /edit "(.*)" project$/
      project = Project.find_by_title $1
      edit_project_path(project)

    when /edit "([^\"]*)" job$/
      job = Job.find_by_title $1
      edit_job_path(job)
      
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
