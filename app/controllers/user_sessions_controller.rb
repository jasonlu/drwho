class UserSessionsController < Devise::SessionsController
  skip_before_filter :check_profile
  

  def after_sign_in_path_for(resource)
    session_id = request.session_options[:id]
    user_id = current_user.id
    carts = Cart.where("session_id = ?", session_id).update_all(:user_id => user_id)
    if current_user.user_profile.nil? || current_user.user_profile.firstname.blank?
      '/profile/edit'
    else
      '/'
    end
  end

end