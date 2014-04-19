class News < ActiveRecord::Base
  attr_accessible :user_id, :close_at, :content, :publish_at, :title
  belongs_to :user
  scope :letest, -> { where("publish_at IS NOT NULL AND close_at >= ?", DateTime.now).order(publish_at: :desc) }
end
