class UploadInfo
  include BaseModel
  include BasePusher

  def get_total
    params = {
      method: 'get',
      fwq: 'http://www.zns.link:8083',
      url: 'v1/total/num'
    }
    result = get_data(params)
    result['data']
  end

  def pusher_data
    pusher_client = get_client
    result = get_real_time_weather
    pusher_client.trigger('test_channel', 'my_event', result);
  end
end
