module WeatherHelper
  def task_status task
    if task.rate >= 90
      content_tag(:i, "严重", class: ["fa", "fa-circle", "fa-red"])
    elsif task.rate >= 75 && task.rate < 90
      content_tag(:i, "主要", class: ["fa", "fa-circle", "fa-orange"])
    elsif task.rate >= 60 && task.rate < 75
      content_tag(:i, "次要", class: ["fa", "fa-circle", "fa-green"])
    end
  end

  # 计算告警发生距现在的时长（min）
  def alarmed_time_to_now(alarm)
  	return "#{((Time.now - alarm.alarmed_at.to_time) / 60).to_i} min"
  end

  # 找到服务器告警发生后的最新记录
  def warn_over_time(alarm)
  	cache = $redis.lindex("#{alarm.identifier}_cpu", -(alarm.rindex + 1))
  	if cache.nil?
  		return nil
  	else
  		return eval(cache)["date_time"].to_time.strftime("%y-%m-%d %H:%M")
  	end
  end
end
