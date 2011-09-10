class Visitor < ActiveRecord::Base
  has_many :checkins
  belongs_to :event
  
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

#  attr_accessible :name, :age

  validates :name, :presence => true
  validates :dob, :presence => true
  validates :address, :presence => true
  validates :gender, :presence => true
  validates :mobile_no, :presence => true
  validates :visitor_type, :presence => true
#  validates :is_guide, :presence => true
  validates :in_gyan_years, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}
  validates :centre_addr, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}
  validates :is_physically_challenged, :presence => true
  validates :event_id, :presence => true

end
