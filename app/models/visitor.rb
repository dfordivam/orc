class Visitor < ActiveRecord::Base
  has_many :checkins
  belongs_to :event
  
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
    self.is_guide = 0
    self.is_driver_along = 0
    self.is_driver_accom_req = 0
    self.is_driver_in_gyan = 0
    self.is_special_care_req = 0
    self.is_physically_challenged = 0
  end

#  attr_accessible :name, :age

  validates :name, :presence => true
  validates :dob, :presence => true
  validates :address, :presence => true
  validates :gender, :presence => true
  validates :mobile_no, :presence => true, :length => 10..10
  validates :visitor_type, :presence => true
  validates :in_gyan_years, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}
  validates :centre_addr, :presence => true, :if => Proc.new { |visitor| visitor.visitor_type == 'bk'}
  validates :is_physically_challenged, :presence => true
  validates :event_id, :presence => true

end
