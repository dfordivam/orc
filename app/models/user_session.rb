# == Schema Information
# Schema version: 20110614113903
#
# Table name: user_sessions
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class UserSession < Authlogic::Session::Base
  def to_key
    [session_key]
  end
end
