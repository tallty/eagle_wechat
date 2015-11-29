class OauthsController < ApplicationController
  # before_action :store_reurl, only: [:index]

  respond_to :html
  
  def index
    # openid = session[:openid]
    # if openid.present?
    target_url = "\/#{params[:target_url]}"
    redirect_to target_url
    # else
    #   url = $group_client.oauth.authorize_url("http://mcu.buoyantec.com/#{params['target_url']}", "STATE#wechat_redirect")
    #   uri = URI.encode(url)
    #   redirect_to uri
    # end
  end

  def check
  end

  def current_customer
    
  end
  
  private
  def store_reurl
    # session[:recurl] += "#{(session[:recurl].include? '?') ? '&' : '?'}body=#{URI.escape(params[:body])}" if params[:body].present?
    session[:target_url] = params[:target_url] if params[:target_url].present?
  end
end
