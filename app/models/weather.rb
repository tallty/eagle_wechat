class Weather
  include BaseModel
  include BasePusher

  def get_real_time_weather
    params = {
      method: 'get',
      fwq: 'http://222.66.83.20:9090',
      url: URI.encode('real_time_weathers/上海')
    }
    result = get_data(params)
    result['datetime'] = result['datetime'].split(' ')[-1]
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
end
