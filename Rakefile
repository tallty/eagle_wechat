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

    # publish/subscribe
    ch = conn.create_channel
    x = ch.fanout('message.task')
    ch.queue('analyze_task', durable: true).bind(x).subscribe do |delivery_info, metadata, payload|
      Rails.logger.warn "#{payload} => analyze_task"
    end

    # ch.queue('alarm_task', durable: true).bind(x).subscribe do |delivery_info, metadata, payload|
    #   Rails.logger.warn "#{payload} => alarm_task"
    # end

    x = ch.fanout('message.interface')
    ch.queue('analyze_interface', durable: true).bind(x).subscribe do |delivery_info, metadata, payload|
      Rails.logger.warn "#{payload} => analyze_interface"
    end

    # ch_task = conn.create_channel
    # ch_task.fanout('message.task')
    # get or create queue (note the durable setting)
    # queue_task = ch_task.queue('worker.task', durable: true)
    # queue_task.bind('message.task')
    #
    # ch_interface = conn.create_channel
    # ch_interface.fanout('message.interface')
    # queue_interface = ch_interface.queue('worker.interface', durable: true)
    # queue_interface.bind('message.interface')
    conn.close
  end
end
