class Admin::UsersController < Admin::BackstageController
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
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

    @admin_users = User.where("type != 'Admin' OR type is NULL").joins(:user_profile).order(sort + ' ' + dir).page(params[:page])    
    render 'index', :locals => {:sort => sort, :dir => dir}

    
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
    @admin_user = User.new

    #@admin_user.profile.new
  end

  # GET /admin/users/1/edit
  def edit
    @admin_user.profile
  end

  # POST /admin/users
  def create
    @admin_user = User.new(admin_user_params)

    if @admin_user.save
      #redirect_to @admin_user, notice: 'User was successfully created.'
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    model = controller_name.classify
    @admin_user.update_attributes(:password => params[:user][:password]) unless params[:user][:password].blank?
    if @admin_user.update!(admin_user_params)
     User.where("roles_mask IS NULL OR roles_mask = 0").update_all(:type => 'User')
     User.where("roles_mask > 0").update_all(:type => 'Admin')
      #redirect_to edit_admin_user_path, notice: 'User was successfully updated.'
      #redirect_to admin_users_path, notice: 'User was successfully updated.'
      redirect_to :controller => controller_name, :action => 'index', notice: "#{model} was successfully updated."
    else
      render action: 'edit'
    end
  end

  def search
    keyword = params[:keyword].to_s
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

    #@admin_users = User.search do
    #  keywords keyword
    #end.results
    keyword = "%#{keyword}%"
    model = controller_name.classify
    profiles = UserProfile.where("
      lastname LIKE ? OR 
      firstname LIKE ? OR 
      education LIKE ? OR 
      country LIKE ? OR 
      register_address LIKE ? OR 
      address LIKE ? OR 
      cellphone LIKE ? OR 
      phone LIKE ? OR 
      dob LIKE ? OR 
      created_at LIKE ? OR
      gender LIKE ?", 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword, 
      keyword).select("user_id")

    if model == 'Admin'
      @admin_users = User.where("(email LIKE ? OR id IN (?)) AND type = ?", keyword, profiles, model).page(params[:page])
    else
      @admin_users = User.where("(email LIKE ? OR id IN (?)) AND (type IS NULL OR type = '' OR type = ?)", keyword, profiles, model).page(params[:page])
    end

    render 'index', :locals => {:sort => sort, :dir => dir}

  end

  # DELETE /admin/users/1
  def destroy
    
    @admin_user.destroy
    
    redirect_to :action => 'index', notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      @admin_user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_user_params
      params.require(:user).permit(:id, :email, :roles => [], user_profile_attributes: [:id, :firstname, :lastname, :id_number, :dob, :gender, :education, :country, :register_address, :address])
      #params[:user]
    end
end
