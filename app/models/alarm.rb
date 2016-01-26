# == Schema Information
#
# Table name: alarms
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  category   :string(255)
#  alarmed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rindex     :integer
#  identifier :string(255)
#

class Alarm < ActiveRecord::Base
  has_many :send_logs
  belongs_to :customer
  belongs_to :user

  after_create :send_message

  def send_message
    articles = [{
      :title => "[告警]#{self.title}",
      :description => "所属模块: #{self.category}\r\n告警时间: #{self.alarmed_at.strftime('%Y-%m-%d %H:%m')}\r\n提示信息: #{self.content}",
      :url => "http://mcu.buoyantec.com/oauths?target_url=alarms/active",
      :picurl => ""
    }]
    $group_client.message.send_news("alex6756|bianandbian", "", "", 1, articles, safe=0)
  end

  # 告警历史记录
  def get_history customer
    customer.alarms.where("end_time is not null")
  end

  # 当前活跃告警
  def get_active customer
    customer.alarms.where("end_time is null")
  end

  # 1分钟轮循任务,判断是否需要告警
  # 检查服务器是否有问题需要告警
  def process
    last_times = $redis.hgetall("machine_last_update_time")
    now_time = Time.now
    last_times.map do |e, v|
      alarm_time = Time.parse(v) + 3.minutes
      # 判断服务器是否正常
      if now_time > alarm_time
        # 从告警表判断此告警信息已经存在:
        #   如果不存在,存入数据库并推送消息
        #   如果存在,判断推送消息记录表是否已经成功推送过此条消息
        #     如果推送过,结束.否则推送消息并写入推送消息日志表
        # machine = Machine.where(identifier: e).first
        machine_hash = Machine.get_machine e
        return if machine_hash.blank?
        machine_name = machine_hash[:name] || machine_hash['name']
        machine_customer = machine_hash[:customer] || machine_hash['customer']
        # 服务器故障时的采集信息列表长度
        length = $redis.llen("#{e}_cpu").to_i
        params = {
          identifier: e,
          title: machine_name,
          category: "服务器",
          alarmed_at: alarm_time,
          rindex: length,
          customer_id: machine_customer,
          content: "超时未收到数据!!!"
        }
        p params
        alarm = Alarm.where(identifier: e, alarmed_at: alarm_time).first
        p alarm
        # 判断是否存在此告警
        if alarm.present?
          # 判断是否推送此消息
          unless alarm.send_logs.present?
            alarm.send_logs.find_or_create_by(accept_user: "alex6756", info: alarm.content)
            alarm.send_message
          end
        else
          alarm = Alarm.create(params)
          alarm.send_logs.find_or_create_by(accept_user: "alex6756", info: alarm.content)
        end
      end
    end
  end

  # 数据采集任务告警
  def build_task_alarm(params={})
    identifier = params[:identifier] || params['identifier']

    alarm = Alarm.where("identifier = ? and end_time is null", identifier).last
    # alarm = Alarm.where(identifier: identifier, alarmed_at: alarmed_at).first
    # 已经存在告警
    if alarm.present?
      unless alarm.send_log.present?
        alarm.send_log.find_or_create_by(accept_user: 'alex6756', info: alarm.content)
        alarm.send_message
      end
    else
      params['alarmed_at'] = now_time
      alarm = Alarm.create(params)
      alarm.send_log.find_or_create_by(accept_user: 'alex6756', info: alarm.content)
    end
  end

end
