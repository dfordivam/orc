# == Schema Information
# Schema version: 20110521152423
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  start_date_time :datetime
#  end_date_time   :datetime
#  capacity        :integer(4)
#  location        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Event < ActiveRecord::Base
end
