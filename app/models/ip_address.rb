# == Schema Information
#
# Table name: ip_addresses
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  count      :integer
#  created_at :datetime
#  updated_at :datetime
#

class IpAddress < ActiveRecord::Base
end
