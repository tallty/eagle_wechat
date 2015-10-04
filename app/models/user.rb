class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone, :name, presence: true
  validates :phone, format: { with: /\A(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\z/, message: "请输入正确的手机号码" }

  attr_accessor :login

  #判断是否需要更新密码
  def update_user(params)
    if params[:password].present? || params[:password_confirmation].present?
      update(params)
    else
      update_without_password(params)
    end
  end

  #使用其他字段登录
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    #where(conditions).where(["phone = :value OR name = :value", { :value => login.strip }]).first
    where(conditions).where(["phone = :value", { :value => login.strip }]).first
  end
  
  protected
  def email_required?
    false
  end
end
