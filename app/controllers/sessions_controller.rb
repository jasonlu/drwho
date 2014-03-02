class SessionsController < Devise::SessionsController
  skip_before_filter :check_profile
  before_filter :set_layout
  def set_layout

    if request.subdomain.match(/(admin)|(xiulia7n0dshuling)/)
      self.class.layout "/admin/layouts/login"
    end
    
  end
end