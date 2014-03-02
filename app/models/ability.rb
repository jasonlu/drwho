class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #user ||= User.new # guest user (not logged in)
    
    #if user.roles.size == 0
    #  can :read, :all #for guest without roles
    #end

    user.roles.each { |role| send(role) }

  end


  def course_manager
    can :manage, Course
  end

  def user_manager
    can :manage, User
  end

  def order_manager
    can :manage, UserOrder
  end

  def service_manager
    can :manage, Message
  end

  def manager
    can :read, :all
  end

  def admin
    #course_manager
    #user_manager
    #order_manager
    #service_manager
    can :manage, :all
  end
end
