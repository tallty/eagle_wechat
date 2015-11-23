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
  has_many :send_log

  after_create :send_message

  def send_message
    $group_client.message.send_text("alex6756", "", "", 1, self.content)
  end

  # 1分钟轮循任务,判断是否需要告警
  def process
    last_times = $redis.hgetall("machine_last_update_time")
    now_time = Time.now
    last_times.map do |e, v| 
      last_time = Time.parse(v) + 1.minutes
      # 判断服务器是否正常
      if now_time > last_time
        # 从告警表判断此告警信息已经存在: 
        #   如果不存在,存入数据库并推送消息
        #   如果存在,判断推送消息记录表是否已经成功推送过此条消息
        #     如果推送过,结束.否则推送消息并写入推送消息日志表
        machine = Machine.where(identifier: e).first
        # 服务器故障时的采集信息列表长度
        length = length = $redis.llen("#{e}_cpu").to_i
        params = { 
          identifier: e, 
          title: machine.name, 
          category: "服务器", 
          alarmed_at: last_time,  
          rindex: length,
          content: "服务器[#{machine.name}]告警:超时未收到数据!!!"
        }
        alarm = Alarm.where(identifier: e, alarmed_at: last_time).first
        # 判断是否存在此告警
        if alarm.present?
          # 判断是否推送此消息
          unless alarm.send_log.present?
            alarm.send_log.find_or_create_by(accept_user: "alex6756", info: alarm.content)
            alarm.send_message
          end
        else
          alarm = Alarm.create(params)
          send_log = alarm.send_log.find_or_create_by(accept_user: "alex6756", info: alarm.content)
        end
      end
    end
  end



	# 判断是否需要告警，并返回告警记录
	def self.avtive_alarms(current_customer)
    cache = {}
    current_customer.machines.each do |machine|
      # 找到服务器最新的告警
      #   如果存在告警，判断告警是否解除
      #     解除：不存入cache；未解除：存入cache
      alarm = Alarm.where(identifier: machine.identifier).last
      if alarm.present?
        if alarm.warn_over_time.nil?
          cache["#{machine.name}"] = ["#{alarm.category}", "#{alarm.alarmed_at}"]
        end
      end
    end
    return cache
	end

	# 告警解除时间
  def warn_over_time
    # 服务器采集信息列表
  	cache = $redis.lindex("#{identifier}_cpu", -(rindex + 1))
    # 接口信息列表 TODO

    # 气象数据信息列表 TODO

  	if cache.nil?
  		return nil
  	else
  		return eval(cache)["date_time"].to_time.strftime("%y-%m-%d %H:%M")
  	end
  end

end
