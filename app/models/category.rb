class Category < ActiveRecord::Base
  attr_accessible :title
  has_many :courses
  validates :title, :presence => true
end
