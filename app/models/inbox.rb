class Inbox < ActiveRecord::Base
  attr_accessible :message_id, :read, :user_id

  belongs_to :user
  belongs_to :message
  
end
