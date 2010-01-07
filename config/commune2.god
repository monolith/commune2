RAILS_ROOT = File.dirname(File.dirname(__FILE__))

def generic_monitoring(w, options = {})
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = options[:memory_limit]
      c.times = [3, 5] # 3 out of 5 intervals
    end
  
    restart.condition(:cpu_usage) do |c|
      c.above = options[:cpu_limit]
      c.times = 5
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end

# STARLING
God.watch do |w|


  w.name = "commune2-starling"
  w.group = "commune2"
  w.interval = 60.seconds

  case RAILS_ENV 

    when "production"
      port = 15151

    when "development"
      port = 22122
  
    else
      port = 12345
  
  end
    
  w.start = "starling -d -P #{RAILS_ROOT}/log/starling.pid -q #{RAILS_ROOT}/log/ -p #{port.to_s}"
  
  w.stop = "kill `cat #{RAILS_ROOT}/log/starling.pid`"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{RAILS_ROOT}/log/starling.pid"
  
  w.behavior(:clean_pid_file)
  
  generic_monitoring(w, :cpu_limit => 30.percent, :memory_limit => 20.megabytes)
end

# WORKLING
God.watch do |w|
  script = "RAILS_ENV=#{RAILS_ENV} #{RAILS_ROOT}/script/workling_client"
  w.name = "commune2-workling"
  w.group = "commune2"
  w.interval = 60.seconds
  w.start = "#{script} start"
  w.restart = "#{script} restart"
  w.stop = "#{script} stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/workling.pid"
  
  w.behavior(:clean_pid_file)
  
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end


# THINKING SPHINX

God.watch do |w|
  script = "cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} rake"
  w.name = "commune2-thinking-sphinx"
  w.group = "commune2"
  w.interval = 60.seconds
  w.start = "#{script} ts:start"
  w.restart = "#{script} ts:restart"
  w.stop = "#{script} ts:stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/searchd.development.pid"
  
  w.behavior(:clean_pid_file)
  
  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end


#God.watch do |w|

#  script = "cd #{RAILS_ROOT} && RAILS_ENV=development lib/daemons/dashboard_reminder_ctl"
#  w.name = "commune2-dashboard-reminder"
#  w.group = "commune2"
#  w.interval = 60.seconds
#  w.start = "#{script} start"
#  w.restart = "#{script} restart"
#  w.stop = "#{script} stop"


#  w.start_grace = 20.seconds
#  w.restart_grace = 20.seconds
#  
#  w.behavior(:clean_pid_file)
#  
#  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)

#end



