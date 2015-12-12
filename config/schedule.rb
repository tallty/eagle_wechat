# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "./log/cron_log.log"
set :job_template, "/usr/bin/timeout 1800 /bin/bash -l -c ':job'"

# Learn more: http://github.com/javan/whenever
every 1.minutes do
  runner 'Alarm.new.process'
end

every 5.minutes do
  runner 'Interface.new.process'
end

every 1.day, :at => '1:45' do
  # runner 'InterfaceReport.process'
end

every 1.day, :at => '8:00' do
  runner 'SendReport.send_report'
end

every 1.minutes do
  runner "TaskLog.new.process"
end
