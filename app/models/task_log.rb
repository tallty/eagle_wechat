# == Schema Information
#
# Table name: task_logs
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  task_identifier :string(255)
#  exception       :string(255)
#  file_name       :text(65535)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  task_name       :string(255)
#

class TaskLog < ActiveRecord::Base
  after_create :verify_task

  def process
    analysis_fetch_data
    # verify_fetch_data
  end

  # 解析接收到的数据,如果数据有异常,报警
  def analysis_fetch_data
    list = $redis.hgetall("task_log_cache")
    now_time = Time.now
    list.map do |e, i|
      # 入库
      item = MultiJson.load(i)
      process_result = item["process_result"]

      if item["task_identifier"].blank?
        $redis.hdel "task_log_cache", e
        next
      end

      log_params = {
        task_identifier: item['task_identifier'],
        start_time: Time.at(process_result['start_time'].to_f),
        end_time: Time.at(process_result['end_time'].to_f),
        exception: process_result['exception'],
        task_name: Task.get_task_name item['task_identifier'],
        file_name: MultiJson.load(process_result['file_list']).join(';')
      }
      log = TaskLog.new.build_task_log(log_params)
      $redis.multi do
        $redis.hset("alarm_task_cache", log.task_identifier, log.start_time)

        $redis.hdel("task_log_cache", e)
      end
    end
  end

  # 数据超时未解析到新数据,告警
  def verify_fetch_data
    tasks = Task.all
    now_time = Time.now
    tasks.each do |task|
      end_time_str = $redis.hget("alarm_task_cache")
      end_time = Time.parse end_time_str
      if (end_time + task.alarm_threshold.minutes) < now_time
        params['content'] = "数据[#{log.task_name}]告警:超时未解析到新数据."
        Alarm.new.build_task_alarm(params)
      end
    end
  end

  def build_task_log(params={})
    log = TaskLog.where(task_identifier: params['task_identifier'], start_time: params['start_time']).first
    if log.blank?
      log = TaskLog.create(params)
      log.save
    end
    return log
  end

  def verify_task
    alarm_params = {identifier: task_identifier, title: machine.name, category: '气象数据', alarmed_at: last_time, rindex: log.id}
    # 数据处理异常,告警
    exception = MultiJson.load(log.exception) rescue ""
    if exception.present?
      alarm_params['content'] = "数据[#{log.task_name}]告警:数据解析异常, 需要马上解决."
      Alarm.new.build_task_alarm(alarm_params)
      next
    end
  end
end
