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
	
  def write_task_info_to_cache
    tasks = Task.all
    tasks.each do |task|
      $redis.hset "tasks_info_cache", task.identifier, task.name
    end
    tasks = nil
  end

  def self.get_task_name identifier
    task_name = $redis.hget "tasks_info_cache", identifier
		if task_name.blank?
			$redis.lpush "error_info_cache", {time: Time.now.strftime("%Y%m%d%H%M"), info: "get task name error", identifier: identifier}.to_json
		end
		task_name || ""
  end

	# 检查气象数据是否正常
  def self.process
    now_time = Time.now
    tasks = Task.where("tasks.rate is NOT NULL")
    tasks.each do |task|
      log = task.find_task_log
      next if log.blank?
      time_out = (now_time - log.created_at) / 60
      last_time = log.created_at + task.rate.minutes
      if log.present? && time_out > task.rate
        params = {
          identifier: task.identifier,
          title: task.name,
          category: "气象数据",
          alarmed_at: last_time,
          rindex: log.id,
          content: "超时未收到数据!!!"
        }
        alarm = Alarm.where(identifier: "#{task.identifier}", alarmed_at: last_time).first
        if alarm.present?
          # 判断是否推送此消息
          unless alarm.send_log.present?
            alarm.send_log.find_or_create_by(accept_user: "alex6756", info: alarm.content)
            alarm.send_message
          end
        else
          alarm = Alarm.create(params)
          alarm.send_log.find_or_create_by(accept_user: "alex6756", info: alarm.content)
        end
      end
    end
  end

	def get_customer_by_task task_identifier
	  task = Task.where(identifier: task_identifier).first
		return task.try(:customer)
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
