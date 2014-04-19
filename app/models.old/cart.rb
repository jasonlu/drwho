class Cart < ActiveRecord::Base
  attr_accessible :course_id, :order_id, :user_id, :session_id
  belongs_to :course
  belongs_to :user
  belongs_to :order
end
