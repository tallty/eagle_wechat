# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  identifier  :string(255)
#  name        :string(255)
#  rate        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

class Task < ActiveRecord::Base
	belongs_to :customer
  has_many :sms_logs, dependent: :destroy
	after_initialize :task_identifier

  def self.process
    now_time = Time.now
    tasks = Task.where("tasks.rate is NOT NULL")
    tasks.each do |task|
      log = task.find_task_log
      time_out = (now_time - log.created_at) / 60
      last_time = log.created_at + task.rate.minutes
      if log.present? && time_out > task.rate
        params = { 
          identifier: task.identifier, 
          title: task.name, 
          category: "气象数据", 
          alarmed_at: last_time, 
          rindex: log.id
        }
        alarm = Alarm.where(identifier: "#{task.identifier}", alarmed_at: last_time)
        if alarm.present?
          # 判断是否推送此消息
          unless alarm.send_log.present?
            send_log = alarm.create_send_log(accept_user: "alex6756", info: "气象数据[#{alarm.title}]告警:超时未收到数据.")
            alarm.send_message
          end
        else
          Alarm.create(params)
          send_log = alarm.create_send_log(accept_user: "alex6756", info: "气象数据[#{alarm.title}]告警:超时未收到数据.")
        end
      end
    end
  end

  # 找到task对应的最新的task_log
  def find_task_log
    TaskLog.where(task_identifier: identifier).last
  end

	private
    def task_identifier
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      self.identifier ||= chars.sample(8).join
    end
end
