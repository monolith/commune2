# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


case RAILS_ENV
  when "production"
    RAILS_ROOT = "/var/www/apps/commune2/current"
  when "development"
    RAILS_ROOT = "~/rails_apps/commune2"
  else
    environment_should_be_skipped = true  
end

unless environment_should_be_skipped # set above in the case statement

  every 2.hours do
    # idea behind doing these every two hours, instead of less frequent
    # because this way there will be less things to do at one time
    # may need to adjust the frequency later

    # reindex with thinking sphinx every 2 hours
    command "cd #{RAILS_ROOT} && rake ts:index RAILS_ENV=#{RAILS_ENV}"
    
    # also send out reminders
    # this is a background task
    command "cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} script/runner MailingsWorker.async_reminders"
  end


  every :reboot do
    # start up god monitoring
    command "god start commune2 -c #{RAILS_ROOT}/config/commune2.god"
  end

  every :sunday, :at => "5:00am" do
    command "rm -rf #{RAILS_ROOT}/tmp/cache"
  end

end
