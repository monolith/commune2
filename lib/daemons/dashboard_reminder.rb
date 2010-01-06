#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production" # defaults to production

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
 
  MailingsWorker.async_reminders # this will check if any reminders are needed, and then mail them
  sleep 15 # waits 15 seconds before checking again


end
