module Admin
  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    skip_before_filter :verify_authenticity_token
    before_filter :authenticate_user!
    layout 'admin/home'

    def current_customer
      Customer.where(id: params[:customer_id]).first
    end
  end

end
