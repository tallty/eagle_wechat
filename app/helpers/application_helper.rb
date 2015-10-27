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
  end

  def pre_time(current_index, current_task_log, task_logs)
    pre_tl = nil
    task_logs.each_with_index do |tl, index|
      if tl['task_identifier'] == current_task_log['task_identifier'] && index < current_index
        pre_tl = tl
      end
    end
    pre_tl.present? ? time_mini(pre_tl['process_result']['start_time'],current_task_log['process_result']['start_time']) : 0.0

  end
  
end
