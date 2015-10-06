class Machine < ActiveRecord::Base
  belongs_to :customer
  has_one :machine_detail
  enum operating_status: { stoped: 0, running: 1 }

  after_initialize :generate_identifier

  private

  def generate_identifier
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.identifier ||= chars.sample(16).join
  end  

end
