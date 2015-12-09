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

    ch_task = conn.create_channel

    ch_task.fanout('message.task')

    ch_interface = conn.create_channel
    ch_interface.fanout('message.interface')

    # get or create queue (note the durable setting)
    queue_task = ch_task.queue('worker.task', durable: true)
    queue_interface = ch_interface.queue('worker.interface', durable: true)

    queue_task.bind('message.task')
    queue_interface.bind('message.interface')
    conn.close
  end
end
