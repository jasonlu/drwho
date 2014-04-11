class Admin::StudiesController < Admin::BackstageController
  before_filter :set_admin_users, :only => [:set_start_day, :record, :wrong_list]
  
  # GET /studies
  # GET /studies.json
  def index
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'category'
      sort = 'categories.title'
    when 'title'
      sort = 'courses.title'
    when 'unit'
      sort = 'courses.unit'
    when 'serial'
      sort = 'courses.serial'
    when 'starts_at', 'ends_at'
    else
      sort = 'starts_at'
    end
    
    @studies = Study.where('user_id = ? AND starts_at <= ?', current_user.id, Time.zone.today).joins(:course).joins(:category).order(sort + ' ' + dir).page(params[:page])
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studies }
    end
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @study = Study.find(params[:id])  
    @gpa = @study.progresses.where('stage = 3').select("AVG(score) AS gpa").first.gpa

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
    end
  end

  
  def set_start_day
    search = params[:search]
#    user = User.where().first

    @user_id = params[:user_id]
    if(@user_id.nil?) 
      @studies = Array.new
    else
      @studies = Study.where(:user_id => @user_id)
    end

    if(!params[:study_id].blank? && request.patch?)
      @study = Study.find(params[:study_id])
      @study.starts_at = params[:starts_at]
      @study.ends_at = @study.starts_at + @study.course.duration_days
      @study.save if params[:save] == 'true'
    end
   
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
    end
    
  end

  

  def hardests
    if(params[:id] == 'all')
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:user_id => current_user.id).group('course_item_id').order('cnt DESC')
      render 'hardest_questions'
    elsif(params[:course_id].nil?)
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:study_id => params[:id], :user_id => current_user.id).group('course_item_id').order('cnt DESC')
      render 'hardest_questions'
    else
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:study_id => params[:id], :user_id => current_user.id).group('course_id').order('cnt DESC')
      render 'hardest_courses'
    end
  end


  def wrong_list
    unless(params[:user_id].nil?)
      user_id = params[:user_id]
      @user = User.find(user_id)
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:user_id => @user.id).group('course_item_id').order('cnt DESC').page(params[:page])
      render "wrong_list_user"
    else
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').group('course_item_id').order('cnt DESC').page(params[:page]) 
      render "wrong_list_all"
    end
  end


  def record
    unless(params[:user_id].nil?)
      user_id = params[:user_id]
      @user = User.find(user_id)
    end
    now = Time.now
    if(params[:study_id].nil?)
      @studies = Study.where("user_id = ?", user_id)
      
      #@records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:study_id => params[:id], :user_id => user_id).group('course_item_id').order('cnt DESC')
      render 'record_all'
    else
      @study = Study.where("user_id = ? AND id = ?", user_id, params[:study_id]).first
      render 'record_courses'
    end
  end


  private
  def set_admin_users
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
  end
end
