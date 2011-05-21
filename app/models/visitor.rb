# == Schema Information
# Schema version: 20110521152423
#
# Table name: visitors
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  age            :integer(4)
#  address        :string(255)
#  gender         :boolean(1)
#  mobile_no      :integer(4)
#  visitor_type   :string(255)
#  designation    :string(255)
#  organisation   :string(255)
#  transport_mode :string(255)
#  checkin_time   :time
#  checkin_date   :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Visitor < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true
end
