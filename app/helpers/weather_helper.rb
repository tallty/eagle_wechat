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
  	((Time.now - alarm.alarmed_at.to_time) / 60).to_i
  end
end
