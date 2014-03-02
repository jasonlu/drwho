class SelfLearning < ActiveRecord::Base

  belongs_to :user
  attr_accessible :original, :translation, :word_type, :order, :user_id, :grouping_id, :serial


end
