class ApplicationController < ActionController::Base
  protect_from_forgery
  #layout "application"
  before_filter :set_cookie
  before_filter :load_config
  before_filter :prepare_sorting
  before_filter :check_new_messages


  def check_new_messages
    @new_messages = 0
    if user_signed_in?
      @new_messages = current_user.inboxes.where(:read => 0).length
    end
  end

  
  def prepare_sorting
    params[:sort] = 'id' if params[:sort].blank?
    sort = params[:sort]
    params[:sort] = params[:sort].sub(/-/, '_')
    params[:dir] = 'desc' if params[:dir].blank?
    dir = params[:dir]    
    sorting_class = sort.downcase.split('.').last + '_' + dir.downcase
    @sorting_class = sorting_class
  end

  

  def check_profile

    if user_signed_in?
      if current_user.user_profile.nil? || current_user.fullname.blank?
        return redirect_to edit_user_profile_path
      end
    end

  end

  def load_config
    
    site_configs = SiteConfig::all
    @config = Hash.new
    site_configs.each do |config|
      @config[config.key.to_sym] = config.value
    end
    
    
    @ads = Hash.new
    @ads[:top_1] = Ad.top_l
    @ads[:top_2] = Ad.top_r
    @ads[:left] = Ad.left
    @ads[:right] = Ad.right
    
    
  end

  def set_cookie
    if cookies[:cart_id].blank?
      session_id = request.session_options[:id]
      cookies[:cart_id] = { :value => session_id, :expires => Time.now + (86400 * 3)}
    end
  end

  def generate_order_number
    session_id = cookies[:cart_id].blank? ? request.session_options[:id] : cookies[:cart_id]
    order_number = Time.now.strftime("%Y%m%d%H%M%S") + session_id.to_i.to_s[0..2]
  end

end