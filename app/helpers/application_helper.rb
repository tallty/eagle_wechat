module ApplicationHelper
  def alert_name(name)
    case name
    when "notice"
      "success"
    when "alert"
      "danger"
    else
      "info"
    end
  end

  def time_mini(start_time, end_time)
    (end_time.to_f - start_time.to_f).round(1)
    # (end_time.to_i - start_time.to_i)/6000
  end
  
end
