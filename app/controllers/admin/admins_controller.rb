class Admin::AdminsController < Admin::UsersController

  def index
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'firstname'
      sort = 'user_profiles.firstname'
    when 'firstname'
      sort = 'user_profiles.lasttname'
    when 'serial'
      sort = 'id'
    when 'email'
    else
      sort = 'id'
    end

    @admin_users = Admin.all.joins(:user_profile).order(sort + ' ' + dir).page(params[:page])    
    render 'index', :locals => {:sort => sort, :dir => dir}

  end


end