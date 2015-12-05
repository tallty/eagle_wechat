# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sneakers/tasks'

Rails.application.load_tasks

namespace :rabbitmq do
  desc 'Setup routing'
  task :setup do
    require 'bunny'
    conn = Bunny.new
    conn.start

    ch = conn.create_channel

    x = ch.fanout('message.task')
    # get or create queue (note the durable setting)
    queue = ch.queue('worker.task', durable: true)

    queue.bind('message.task')
    conn.close
  end
end
