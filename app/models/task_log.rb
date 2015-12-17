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
    tasks = Task.where('alarm_threshold is not null')
    now_time = Time.now
    tasks.each do |task|
      end_time_str = $redis.hget("alarm_task_cache", task.identifier)
      next if end_time_str.blank?
      end_time = Time.parse end_time_str
      if (end_time + task.alarm_threshold.minutes) < now_time
        params = {identifier: task.identifier, title: '', category: '气象数据'}
        params['content']  = "数据[#{task.name}]告警:超时未解析到新数据."
        params['customer'] = task.customer
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
    alarm_params = {
      identifier: task_identifier,
      title:      task_name,
      category:   '气象数据',
      alarmed_at: Time.now,
      rindex:     id,
      customer:   Task.where(identifier: task_identifier).first.customer
    }
    # 数据处理异常,告警
    exception = MultiJson.load(exception) rescue ""
    if exception.present?
      alarm_params['content'] = "数据[#{task_name}]告警:数据解析异常, 需要马上解决."
      Alarm.new.build_task_alarm(alarm_params)
    end
  end
end
