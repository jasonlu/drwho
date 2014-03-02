class StudiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_profile
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

  def practice
    @study = Study.find(params[:id])
    @day = params[:day]
    @phase = params[:phase].to_i
    @course_items = @study.course.course_items.where('day = ?', @day)
    @type = 'practice'

    @action_target = 'practice_submit'
    case @phase
    when 0

      render 'practice_0'

    when 1

      render 'practice_1'

    when 2

      render 'practice_2'
    
    else

      render 'practice_0'
    end
  end

  def exam
    @study = Study.find(params[:id])
    @day = params[:day].to_i
    @phase = params[:phase].to_i
    @course_items = @study.course.course_items.where('day = ?', @day)
    @type = 'exam'
    @action_target = 'exam_submit'

    if @phase < 3 #DESC
      @course_items = @study.course.course_items.where('day <= ? AND day > ?', @day,  @day - 10).order('day DESC, id DESC')
    elsif @phase < 6 #ASC
      @course_items = @study.course.course_items.where('day <= ? AND day > ?', @day,  @day - 10).order('day ASC, id ASC')
    elsif @phase < 9 #DESC odd, even
      @course_items = @study.course.course_items.where('day <= ? AND day > ?', @day,  @day - 10).order('day DESC, id DESC').partition {|v| v.id.even? }
      course_items_even = @course_items[0]
      course_items_odd = @course_items[1]
      @course_items = course_items_odd.concat(course_items_even)
    elsif @phase < 12 #DESC even, odd
      @course_items = @study.course.course_items.where('day <= ? AND day > ?', @day,  @day - 10).order('day DESC, id DESC').partition {|v| v.id.even? }
      course_items_even = @course_items[0]
      course_items_odd = @course_items[1]
      @course_items = course_items_even.concat(course_items_odd)
    end
    
    case @phase
    when 0, 3, 6, 9
      render 'practice_0'
    when 1, 4, 7, 10
      render 'practice_1'
    when 2, 5, 8, 11
      render 'practice_2'

    end
  end

  def practice_submit
    @type = 'practice'
    @phase = params[:phase].to_i
    compare_result(2)

    #redirect_to @study
    render 'practice_result'
  end

  def exam_submit
    @type = 'exam'
    @phase = params[:phase].to_i
    compare_result(3)

    #redirect_to @study
    render 'practice_result'
  end

  def read
    @study = Study.find(params[:id])
    @day = params[:day]
    @course_items = @study.course.course_items.where('day = ?', @day)

    if @study.progresses.where('stage = 1 AND day = ?', @day).first.nil?
      @study.progresses.create(
        :user_id => current_user.id,
        :course_id => @study.course_id,
        :day => @day,
        :course_item_id => @study.course.course_items.first.id,
        :stage => 1
      )
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
    end
  end

  def set_start_day
    @study = Study.find(params[:id])
    @study.starts_at = params[:starts_at]
    @study.ends_at = @study.starts_at + @study.course.duration_days

    @study.save if params[:save] == 'true'
    
    render :json => @study
  end

  def compare_result(stage)
    @study = Study.find(params[:id])
    @day = params[:day]
    
    course_ids = Array.new
    @results = Hash.new
    
    total_questions = params[:course_items].length.to_i
    
    phase = params[:phase].to_i
    total_wrongs = 0.0
    params[:course_items].each do |key, value|
      course_ids.push(key.to_i)
      ci = CourseItem.find(key.to_i)
      #wrong = ci.question.downcase.gsub(/[^0-9a-z]/i, '') != value.downcase.gsub(/[^0-9a-z]/i, '')  ? true : false
      wrong = ci.question != value ? true : false
      value = '__' if value == ''
      result = {:content => value, :wrong? => wrong}
      @results[key.to_i] = result

      if wrong
        StudyRecord.create(
          :user_id => current_user.id,
          :course_item_id => key.to_i,
          :content => value,
          :study_id => @study.id,
          :course_id => @study.course_id,
          :stage => stage,
          :phase => phase
        )
        total_wrongs += 1
      end
      @score = (1 - total_wrongs / total_questions) * 100
      @score = @score.round(0)
    end
    @course_items = CourseItem.where(:id => course_ids)#.order("FIELD(id, (?))", course_ids)

    Progress.create(
      :user_id => current_user.id,
      :course_item_id => 0,
      :study_id => @study.id,
      :course_id => @study.course_id,
      :stage => stage,
      :phase => phase,
      :day => @day,
      :score => @score
    )
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

  def records
    if(params[:course_id].nil?)
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:study_id => params[:id], :user_id => current_user.id).group('course_item_id').order('cnt DESC')
      render 'record_all'
    else
      @records = StudyRecord.select('course_item_id, count(*) AS cnt, course_id, study_id').where(:study_id => params[:id], :user_id => current_user.id).group('course_id').order('cnt DESC')
      render 'record_courses'
    end
  end

 
    
end
