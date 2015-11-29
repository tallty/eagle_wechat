class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_customer


  def current_customer
  	# Customer.first
    openid = session[:openid]
    @member = Member.where(openid: openid).first
    @customer = @member.customer || Customer.first
  end 
end
