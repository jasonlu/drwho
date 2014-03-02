class Admin::BackstageController < ActionController::Base
  protect_from_forgery
  layout "/admin/layouts/application"
  #before_filter :check_profile
  before_filter :get_controller_list
  before_filter :load_config
  before_filter :prepare_sorting
  before_filter :authenticate_user!

  before_filter :set_layout
  
  def get_controller_list
    
  
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


  def set_layout
    self.class.layout "admin/layouts/login" unless user_signed_in?

  end

  def after_sign_in_path_for(resource)
    '/'
  end

  def load_config

    site_configs = SiteConfig::all
    @config = Hash.new
    site_configs.each do |config|

      @config[config.key.to_sym] = config.value

    end
    

  end


end