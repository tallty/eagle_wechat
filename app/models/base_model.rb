module BaseModel

  def init_connect(url=nil)
    @connect = Faraday.new(:url => url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def get_data(params={}, head_params={})
    fwq_url = params[:fwq] || params['fwq']
    init_connect(fwq_url)
    method = params[:method] || params['method']
    result = send("use_#{method}", params, head_params)
  end

  private
  def use_post(params={}, head_params={})
    data_url = params[:url] || params['url']
    request_params = params[:data] || params['data']
    response = @connect.post do |request|
      request.url data_url
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      if head_params.present?
        phone = head_params[:phone] || head_params['phone']
        token = head_params[:token] || head_params['token']
        request.headers['X-User-Phone'] = phone
        request.headers['X-User-Token'] = token
      end
      request.body = request_params.to_json
    end
    MultiJson.load response.body rescue {}
  end

  def use_get(params={}, head_params={})
    data_url = params[:url] || params['url']
    request_params = params[:data] || params[:data]
    response = @connect.get do |request|
      request.url data_url
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      if head_params.present?
        phone = head_params[:phone] || head_params['phone']
        token = head_params[:token] || head_params['token']
        request.headers['X-User-Phone'] = phone
        request.headers['X-User-Token'] = token
      end
      request.body = request_params.to_json
    end
    MultiJson.load response.body rescue {}
  end
end
