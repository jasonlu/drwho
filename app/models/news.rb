class News < ActiveRecord::Base
  attr_accessible :user_id, :close_at, :content, :publish_at, :title
  belongs_to :user

end
