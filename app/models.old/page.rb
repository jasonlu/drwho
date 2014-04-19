class Page < ActiveRecord::Base
  attr_accessible :body, :key, :title
  validates :key, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :title, :presence => true

end
