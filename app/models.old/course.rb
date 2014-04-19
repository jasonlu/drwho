class Course < ActiveRecord::Base

  before_validation :generate_serial
  before_create :generate_uuid

  has_many :course_items, :dependent => :delete_all, :inverse_of => :course
  belongs_to :category
  belongs_to :group

  accepts_nested_attributes_for :course_items, allow_destroy: true
  attr_accessible :course_items_attributes, :allow_destroy => true
  attr_accessible :briefing, :category_id, :description, :due_at, :duration_days, :end_at, :group_id, :price, :start_at, :title, :unit, :serial
  #has_one :category
  
  
  validates :title, :presence => true
  validates :price, :presence => true
  #validates :group_id, :presence => true
  validates :duration_days, :presence => true
  validates :category_id, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  validates :due_at, :presence => true
  validates :serial, :presence => true, :uniqueness => true

  def self.generate_serial
    'C' + Time.now.to_i.to_s
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
  
  def generate_serial
    serial = self.class.where(:category_id => self.category_id).length
    serial = serial + 1
    serial = serial.to_s.rjust(3, '0')
    self.serial =  'C' + self.category_id.to_s.rjust(3, '0') + 'N' + serial
  end

  def activate?
    if self.end_at == self.start_at
      return false
    else
      return true
    end
  end

  def can_signup?
    if self.due_at >= Date.today
      return true
    else
      return false
    end
  end


end
