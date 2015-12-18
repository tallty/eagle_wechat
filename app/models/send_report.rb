class SendReport

  # 发送日报
  def self.send_report
    articles = []
    now_day = Time.now
    today = now_day - 1.day
    if now_day.strftime("%u").eql?("1")
      articles << {:title => "#{today.strftime('%Y年第%W周监控报表')}", :url => "http://mcu.buoyantec.com/oauths?target_url=reports/week", :picurl => "http://mcu.buoyantec.com/assets/images/week_report.png"}
    end
    articles << {:title => "#{today.strftime('%Y年%m月%d日监控报表')}", :url => "http://mcu.buoyantec.com/oauths?target_url=reports&date=#{now_day.strftime('%Y-%m-%d')}", :picurl => "http://mcu.buoyantec.com/assets/images/day_report.png"}
    $group_client.message.send_news("", "4", "", 1, articles, safe=0)
  end

end
