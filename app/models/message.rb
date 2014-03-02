class Message < ActiveRecord::Base
  attr_accessible :content, :subject, :user_id
  has_many :inboxes, :dependent => :destroy
  has_many :users, through: :inboxes
  
  belongs_to :sender, :foreign_key => 'user_id', :class_name => "User"
  belongs_to :sender_profile, :foreign_key => 'user_id', :class_name => "UserProfile"
  
  RECEIVERS = {:everyone => '所有人', :male => '男性', :female => '女性', :birthday_person => '本月壽星'}
end
