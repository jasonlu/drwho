class UserRegistrationsController < Devise::RegistrationsController

  def create
    # super
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        give_free_courses
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        give_free_courses
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
    
  end

  protected
  
  def give_free_courses
    # /super
    
    courses = Course.where(:price => 0)
    course_ids = Array.new
    courses.each do |course|
      course_ids.push(course.id)
    end
    courses_string = course_ids.join(',')
    order_number = generate_order_number()
    order = resource.user_orders.create(:payment_method => -1, :payment_status => 1, :payment_price => 0, :courses => courses_string, :order_number => order_number)
    courses.each do |course|
      resource.studies.create(
        :user_order_id => order.id,
        :course_id => course.id,
        :starts_at => Date.today,
        :ends_at => Date.today + course.duration_days - 1
      )
    end
    
  end
  def after_sign_up_path_for(resource)
    profile = UserProfile.new
    profile.user_id = current_user.id
    profile.save
    '/profile/edit'
  end

  def after_inactive_sign_up_path_for(resource)
    #'/profile/new'
    new_user_confirmation_path
  end
end   