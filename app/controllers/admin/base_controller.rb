class Admin::BaseController < ApplicationController
  # before_action :authenticate_admin!, :set_left_bar
  before_action :authenticate_user!
  layout 'admin'

  def current_customer
    logger.warn params
    Customer.where(id: params[:customer_id]).first
  end
  
  # 侧边栏所有菜单
  def set_left_bar
  	@systems = System.includes(sub_systems: :patterns).all
  end
end
