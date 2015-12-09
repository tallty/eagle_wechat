# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sneakers/tasks'

Rails.application.load_tasks

namespace :rabbitmq do
  desc 'Setup routing'
  task :setup do
    require 'bunny'
    conn = Bunny.new(:automatically_recover => false)
    conn.start

    ch = conn.create_channel

    ch.fanout('message.task')
    ch.fanout('message.interface')

    # get or create queue (note the durable setting)
    queue_task = ch.queue('worker.task', durable: true)
    queue_interface = ch.queue('worker.interface', durable: true)

    queue.bind('message.task')
    queue.bind('message.interface')
    conn.close
  end
end
