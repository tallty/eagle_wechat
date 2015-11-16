class InterfacesApiUser < ActiveRecord::Base
  belongs_to :interface
  belongs_to :api_user
end
