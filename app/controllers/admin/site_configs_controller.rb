class Admin::SiteConfigsController < Admin::BackstageController

  def index
    
  end

  def update
    params.each do |key, value|
      case key
      when 'utf8', '_method', 'authenticity_token'
        next
      end
      config = SiteConfig.find_by_key(key)
      config.update_attribute('value', value) unless config.nil?
    end

    redirect_to url_for(:controller => 'site_configs', :action => 'index')
  end
end
