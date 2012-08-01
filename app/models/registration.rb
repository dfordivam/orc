class Registration < ActiveRecord::Base

  belongs_to :visitor
  belongs_to :event
  has_many :accompany_visitors #, :conditions => "is_delete=false"
#  has_many :checkins
  has_one :checkin, :as => :source


  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
  end

  validates :event_id, :presence => true
  validates :visitor_id, :presence => true

  def participants
    @participants = []
    @participants += [Participant.from_registration(self)]
    avs = self.accompany_visitors
    avs.each do |av|
      @participants += [Participant.from_accompany_visitor(av)]
    end
    return @participants
  end
end
