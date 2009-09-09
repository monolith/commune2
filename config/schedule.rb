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
  # need to do this as sameuser as the deployment user
  command "su depl0y && cd /var/www/apps/commune2/current"
  rake "thinking_sphinx:index RAILS_ENV=production"
end

every :reboot do
  # need to do this as sameuser as the deployment user
  command "su depl0y && cd /var/www/apps/commune2/current"
  rake "thinking_sphinx:start RAILS_ENV=production"
end

every :sunday, :at => "5:00am" do
  command "rm -rf #{RAILS_ROOT}/tmp/cache"
end

