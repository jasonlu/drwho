class Progress < ActiveRecord::Base
  attr_accessible :study_id, :course_id, :course_item_id, :user_id, :day, :stage, :created_at, :phase, :score
  belongs_to :user
  belongs_to :study
  belongs_to :course_item
  belongs_to :course

  
end
