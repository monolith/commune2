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



every 2.hours do
  # idea behind doing these every two hours, instead of less frequent
  # because this way there will be less things to do at one time

  # reindex with thinking sphinx every 2 hours
  command "cd /var/www/apps/commune2/current && rake ts:index RAILS_ENV=production"
  
  # also send out reminders
  # this is a background task
  #  runner "MailingsWorker.async_reminders"
end

#every 5.minutes do
#  #this is just a quick test and should be removed
#  runner "MailingsWorker.async_reminders"
#end



every :reboot do

  # start up thinking sphinx after reboot
  command "cd /var/www/apps/commune2/current && rake ts:start RAILS_ENV=production"
  
  # for background stuff
  # start up starling...
#  command "starling -d -P tmp/pids/starling.pid -q log/ -p 15151"

  # and we need workling...
#  command "RAILS_ENV=production ./script/workling_client start -t"    
end

every :sunday, :at => "5:00am" do
  command "rm -rf #{RAILS_ROOT}/tmp/cache"
end
