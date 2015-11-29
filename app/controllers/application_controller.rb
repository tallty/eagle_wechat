class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_customer

  def current_customer
    # Customer.first
    openid = session[:openid]
    customer = nil
    if openid.blank?
      customer = Customer.first
    else
      member = Member.where(openid: openid).first
      customer = member.customer or Customer.first
    end
    return customer
  end 
end
