class Weather
  include BaseModel
  include BasePusher

  def run
    urls = ["publicdata/data?type=ten_day_forecast&appid=3b9Xc0Xky1dM155537Au&appkey=OGSi7t39lB13d00L78vr53Fxgj7D5i",
      "publicdata/data?type=country_forcast&appid=3b9Xc0Xky1dM155537Au&appkey=OGSi7t39lB13d00L78vr53Fxgj7D5i&city=北京"]
    250.times do |i|
      urls.each do |url|
        params = {
          method: 'get',
          fwq: 'http://61.152.122.112:8080',
          url: URI.encode(url)
        }
        result = get_data(params, {})
      end
    end
	end

  def get_real_time_weather
    params = {
      method: 'get',
      fwq: 'http://222.66.83.20:9090',
      url: URI.encode('real_time_weathers/上海')
    }
    result = get_data(params)
    result['datetime'] = result['datetime'].split(' ')[-1]
    result['weather'] = get_pic_file result['weather']
    result
  end

  def get_district_weather
    params = {
      method: 'get',
      fwq: 'http://222.66.83.20:9090',
      url: 'sh_main_stations'
    }
    result = get_data(params)
  end

  def pusher_data
    pusher_client = get_client
    result = get_real_time_weather
    pusher_client.trigger('test_channel', 'my_event', result);
  end

  def get_pic_text text
    weather_list = ["暴雪", "暴雨", "大暴雨", "特大暴雨", "强沙尘暴", "大雪", "大雨",
      "冻雨", "浮尘", "阵雨", "雷阵雨", "沙尘暴", "雾", "小雪", "小雨", "扬沙", "阴",
      "雨夹雪", "中雪", "中雨", "晴", "多云", "冰雹", "阵雪", "浓雾", "强浓雾", "霾",
      "中度霾", "重度霾", "严重霾", "大雾", "特强浓雾"]
    text if weather_list.include?(text)
  end

  def get_pic_file text
    bg_image_list = {
      "暴雪" => "weather_super_snow.png",
      "暴雨" => "weather_rainstorm.png",
      "大暴雨" => "weather_big_rainstorm.png",
      "特大暴雨" => "weather_super_rainstorm.png",
      "强沙尘暴" => "weather_sandstorm.png",
      "大雪" => "weather_big_snow.png",
      "大雨" => "weather_big_rain.png",
      "冻雨" => "weather_sleet_rain.png",
      "浮尘" => "weather_dust.png",
      "阵雨" => "weather_shower_rain.png",
      "雷阵雨" => "weather_thunder_rain.png",
      "沙尘暴" => "weather_sandstorm.png",
      "雾" => "weather_fog.png",
      "霾" => "weather_haze.png",
      "小雪" => "weather_little_snow.png",
      "小到中雪" => "weather_s_m_snow.png",
      "小雨" => "weather_little_rain.png",
      "扬沙" => "weather_jansa.png",
      "阴" => "weather_overcast.png",
      "雨夹雪" => "weather_sleet.png",
      "中雪" => "weather_mid_snow.png",
      "中雨" => "weather_mid_rain.png",
      "晴" => "weather_sunny.png",
      "多云" => "weather_cloudy.png",
      "冰雹" => "weather_hail.png",
      "阵雪" => "weather_big_snow.png"
    }
    return bg_image_list[text]
  end
end
