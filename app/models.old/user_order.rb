class UserOrder < ActiveRecord::Base
  attr_accessible :order_number, :courses, :payment_method, :payment_price, :payment_status, :user_id, :note
  belongs_to :user
  has_many :studies
  paginates_per 10

  def price
    if self.payment_price.to_i == self.payment_price
      self.payment_price.to_i 
    else
      self.payment_price
    end
  end

  def course_list
    Course.find(self.courses.split(','))
  end

  def order_number

    if(self.read_attribute(:order_number).blank?) 
      I18n.t("FREE_COURSE")
    else
      order_number = self.read_attribute(:order_number)
    end
     #unless self.read_attribute(:order_number).blank?
    
  end
end
