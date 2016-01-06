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

  # 无用, 清理
  def self.check_task

    $redis.hgetall("task_log_cache").each do |key, value|
      identifier, time = key.split("_")

      # 将处理日志详情加入到数据库
      add_task_log value

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

      $redis.hdel("task_log_cache", key)
    end
  end

  def self.send_task_notification task, current_state
    members = task.try(:customer).try(:members)

    sended_users = members.group(:openid).pluck(:openid)
    sended_users << "alex6756"

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

  def self.add_task_log task_detail
    task_hash = MultiJson.load task_detail

    file_logs = eval(task_hash["process_result"]["file_list"])
    now_date = DateTime.now.to_date
    file_name = ""

    # 找出今天的文件，若没有，则返回。
    file_logs.each do |file_log|
      log_time = file_log.first
      if DateTime.strptime(log_time, "%Y-%m-%dT%H:%M:%S.%L%z").to_date == now_date
        file_name = file_log.last
      end
    end
    return if file_name.empty?

    start_time = Time.at(task_hash["process_result"]["start_time"].to_f)
    end_time = Time.at(task_hash["process_result"]["end_time"].to_f)

    TaskLog.create(start_time: start_time, end_time: end_time, task_identifier: task_hash["identifier"],
      exception: hash["process_result"]["exception"], file_name: file_name)
  end

end
