class ClickRecord < ActiveRecord::Base
  attr_accessible :url, :referer, :ad_id, :from, :created
  belongs_to :ad

end
