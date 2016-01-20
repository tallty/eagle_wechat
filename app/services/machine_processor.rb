class MachineProcessor

  # 解析接收到的服务器状态数据,如果数据有异常,报警
  def self.push(raw_post)
    real_hardware_params = MultiJson.load raw_post rescue {}
    return if real_hardware_params.blank?
    identifier = real_hardware_params['identifier'] || real_hardware_params[:identifier]
    $redis.multi do
      $redis.lpush "#{identifier}_cpu", "#{real_hardware_params['info']['cpu']}"
      $redis.lpush "#{identifier}_memory", "#{real_hardware_params['info']['memory']}"
      $redis.lpush "#{identifier}_net_work", "#{real_hardware_params['info']['net_work']}"
      $redis.lpush "#{identifier}_file_systems", "#{real_hardware_params['info']['file_system']}"
      $redis.hset("machine_last_update_time", "#{identifier}", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
      $redis.ltrim "#{identifier}_cpu", 0, 8640
      $redis.ltrim "#{identifier}_memory", 0, 8640
      $redis.ltrim "#{identifier}_net_work", 0, 8640
      $redis.ltrim "#{identifier}_file_systems", 0, 8640
    end
    alarm = Alarm.where(identifier: identifier, end_time: nil).last
    p ">>>>>>>>>>>>>>>>>> #{alarm.inspect}"
    if alarm
      alarm.updated_attribute(:end_time, Time.now)
    end
  end

end
