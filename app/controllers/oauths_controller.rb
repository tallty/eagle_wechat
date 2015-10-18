class OauthsController < ApplicationController
  before_action :store_reurl, only: [:index]

  respond_to :html
  
  def index
    openid = session[:openid]
    if openid.present?
      redirect_to session[:recurl] || game_path
    else
      url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx02a2998a8f377c0b&redirect_uri=http://shtzr198434.tunnel.mobi/#{params['target_url']}&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect"
      redirect_to url
    end
  end

  def check
  
  end

  private
  def store_reurl
    session[:recurl] = params[:recurl] if params[:recurl].present?
    session[:recurl] += "#{(session[:recurl].include? '?') ? '&' : '?'}body=#{URI.escape(params[:body])}" if params[:body].present?
    session[:target_url] = params[:target_url] if params[:target_url].present?
  end
end
