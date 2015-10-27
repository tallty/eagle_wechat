# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :job_template, "/usr/bin/timeout 1800 /bin/bash -l -c ':job'"

# Learn more: http://github.com/javan/whenever

every 1.day, :at => '1:45' do
  runner 'InterfaceReport.process'
end

every 1.minutes do
  runner "TaskLog.process"
end
