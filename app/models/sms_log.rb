# == Schema Information
#
# Table name: sms_logs
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  customer_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  warning_state :boolean
#  task_id       :integer
#

class SmsLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :task
  def self.send_task_notification task, current_state
    members = task.try(:customer).try(:members)
    sended_users = members.group(:openid).pluck(:openid)

    if current_state
      # 告警内容
      text_message = "[上海气象局科科技服务中心]#{task.name}."
    else
      # 取消告警内容
      text_message = "[上海气象局科科技服务中心]#{task.name}."
    end
    task.create(content: text_message, customer: task.try(:customer), warning_state: current_state)
    $group_client.message.send_text(sended_users, [], [], 1, text_message)
  end

  def self.check_task
    $redis.hgetall("task_log_cache").keys.each do |key|
      identifier, time = key.split("_")
      
      task = Task.find_by(identifier: identifier)
      next unless task.present?

      # 上一次上报的时间
      now_time = DateTime.now.to_i
      last_state = task.sms_logs.last.warning_state
      current_state = ((now_time - time.to_i)/60 > task.rate)

      # 当告警状态变化时，发送提醒
      if current_state == !last_state
        send_task_notification task, current_state
      end
    end
  end
end
