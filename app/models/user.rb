class User < ActiveRecord::Base
  
  has_many :user_orders, :dependent => :destroy
  has_many :self_learnings, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :inboxes, :dependent => :destroy
  has_many :messages, through: :inboxes, :dependent => :destroy
  has_many :studies, :dependent => :destroy
  has_many :study_records, :dependent => :destroy
  has_many :progresses, :dependent => :destroy
  has_one :user_profile, :dependent => :destroy
  has_one :profile, :foreign_key => 'user_id', :class_name => 'UserProfile'
  before_create :build_user_profile

  accepts_nested_attributes_for :profile, :user_profile

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :confirmable
  #:rememberable, 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :roles, :remember_me, :user_profile_attributes

  ROLES = %w[admin manager course_manager order_manager user_manager banned]
  # attr_accessible :title, :body

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def fullname
    unless self.nil? and self.profile.nil?
      return '' if(self.profile.lastname.blank? || self.profile.firstname.blank?)
      self.profile.lastname + ' ' + self.profile.firstname
    else
      'System Manager'
    end
  end

  def serial_id
    (1000065535 + self.id).to_s
  end

end
