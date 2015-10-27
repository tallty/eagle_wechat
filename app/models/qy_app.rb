# == Schema Information
#
# Table name: qy_apps
#
#  id               :integer          not null, primary key
#  qy_token         :string(255)
#  encoding_aes_key :string(255)
#  corp_id          :string(255)
#  qy_secret_key    :string(255)
#

class QyApp < ActiveRecord::Base
  before_create :init_qy_secret_key

  private
    def init_qy_secret_key
      self.qy_secret_key = SecureRandom.hex(8)
    end
end
