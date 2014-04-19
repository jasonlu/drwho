class Study < ActiveRecord::Base
  before_create :generate_uuid
  attr_accessible :user_order_id, :course_id, :progress_id, :status, :user_id, :score, :starts_at, :ends_at, :passed
  belongs_to :course
  belongs_to :user_order
  has_one :category, :through => :course
  has_many :progresses
  has_many :study_records

  def progress_day
    return 1 if self.progresses.order('day DESC').last.nil?
    self.progresses.last.day
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
