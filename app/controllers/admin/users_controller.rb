module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_users, only: [:index]

    def index
      @customers = Customer.all
    end

    def new
      
    end

    private
    def set_users
      @users = User.all
    end
  end
end
