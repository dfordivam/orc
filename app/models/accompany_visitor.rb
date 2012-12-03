class AccompanyVisitor < ActiveRecord::Base
#belongs_to :visitor
belongs_to :registration
belongs_to :event
has_one :checkin, :as => :source

  def participant
    return Participant.from_accompany_visitor(self)
  end
end
