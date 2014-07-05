class StudiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_profile
  before_filter :select_studies, :only => [:index, :all_records]
  before_filter :select_study, :only => [:show, :record, :read, :practice, :exam, :compare_result]

  def index
    now = Time.now
    @studies = @studies.where('ends_at >= ?', now)
  end

  def show
  end

  def record
    @user = current_user
    @records = @study.study_records.select('course_item_id, count(*) AS cnt, course_id, study_id').group('course_id').order('cnt DESC')
    render 'record_courses'
  end

  def all_records
    @current_section = 'account'
    now = Time.now
    @studies = @studies.where('ends_at <= ?', now)
    render 'record_all'
  end

  def practice
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

  def exam_submit
    @type = 'exam'
    @phase = params[:phase].to_i
    uuid = compare_result(3)

    if uuid
      redirect_to study_exam_result_path(:uuid => uuid)
    else
      flash[:error] = t("errors.messages.duplicate_exam_submit")
      redirect_to study_path(:uuid => params[:uuid])
    end

  end

  def practice_submit
    @type = 'practice'
    @phase = params[:phase].to_i
    uuid = compare_result(2)
    if uuid
      redirect_to study_practice_result_path(:uuid => uuid)
    else
      redirect_to study_path(:uuid => params[:uuid])
    end
  end

  def exam_result
    stage = 3
    get_result(stage)
  end

  def practice_result
    stage = 2
    get_result(stage)
  end

  def read
    @study = current_user.studies.where("uuid = ?", params[:uuid]).first
    @course = @study.course
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
  end

  def set_start_day
    if request.patch?
      @study = current_user.studies.where("uuid = ?", params[:uuid]).first
      @study.starts_at = params[:starts_at]
      @study.ends_at = @study.starts_at + @study.course.duration_days - 1

      @study.save if params[:save] == 'true'
      
      render :json => @study
      return

    else
      sort = params[:sort]
      dir = params[:dir]

      case sort
      when 'price'
        sort = 'payment_price'
      when 'order_number', 'id', 'created_at'
      when 'title'
        sort = 'courses.title'
      when 'category'
        sort = 'categories.title'
      else
        sort = 'order_number'
      end
      @current_section = 'account'
      @studies = current_user.studies.where("starts_at > ? OR starts_at IS NULL", Time.now()).joins(:user_order).joins(:course => :category).group("studies.id").order(sort + ' ' + dir).page(params[:page])
      
      if @studies.length == 0
        render "set_start_day_none"
      else
        render "set_start_day"
      end
    end
  end


:private

  def compare_result(stage)
    @study = current_user.studies.where("uuid = ?", params[:uuid]).first
    @day = params[:day]
    @phase = params[:phase].to_i
    save_progress = true

    p = @study.progresses.where(:day => @day, :stage => stage, :phase => @phase).first
    unless p.nil?
      save_progress = false
      puts "WILL NOT SAVE"
      if stage == 3
        return false
      end
    end
    
    user_id = current_user.id
    study_id = @study.id
    course_id = @study.course_id

    course_ids = Array.new
    @results = Hash.new
    
    total_questions = params[:course_items].length.to_i
    total_wrongs = 0.0
    @try = Try.new
    
    Progress.transaction do
      params[:course_items].each do |key, value|
        course_ids.push(key.to_i)
        ci = CourseItem.find(key.to_i)
        #wrong = ci.question.downcase.gsub(/[^0-9a-z]/i, '') != value.downcase.gsub(/[^0-9a-z]/i, '')  ? true : false
        wrong = ci.question != value ? true : false
        value = '__' if value == ''
        
        StudyRecord.create(
          :user_id => user_id,
          :course_item_id => key.to_i,
          :content => value,
          :study_id => study_id,
          :course_id => course_id,
          :wrong => wrong,
          :stage => stage,
          :phase => @phase,
          :try_id => @try.id
        )
        if wrong
          total_wrongs += 1
        end
      end # end of loop

      @score = (1 - total_wrongs / total_questions) * 100

      @try.score = @score.round(2)
      @try.user_id = user_id
      @try.study_id = study_id
      @try.course_id = course_id
      @try.day = @day
      @try.phase = @phase
      @try.stage = stage
      @try.save

      @score = @score.round(0)
      if save_progress
        Progress.create(
          :user_id => current_user.id,
          :course_item_id => 0,
          :study_id => @study.id,
          :course_id => @study.course_id,
          :stage => stage,
          :phase => @phase,
          :day => @day,
          :score => @score
        )
      end
    end # end of transaction
    return @try.id
  end # end of method

  def get_result(stage)
    @try = Try.where(:id => params[:uuid]).first
    if @try.nil?
      redirect_to studies_path
      return
    end

    @study = current_user.studies.where(:id => @try.study_id).first
    @day = @try.day
    @phase = @try.phase
    @stage = @try.stage
    @progress = @study.progresses.where(
      :course_id => @study.course_id,
      :stage => @stage,
      :phase => @phase,
      :day => @day,
    ).order("id ASC").last
    
    @study_records = @try.records.order("id ASC").all
    @score = @try.score.round(0)
  end

  def select_studies
    @current_section = 'studies'
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
    
    now = Time.now
    # starts_at: utc date only.
    # now: local time date and time.
    @studies = current_user.studies.where('starts_at <= ?', now).joins(:course).joins(:category).order(sort + ' ' + dir).page(params[:page])
    # DateTime.now.beginning_of_day
    # DateTime.now.end_of_day
    @studies.each do |study|
      end_day = study.ends_at.to_time.end_of_day

      if end_day < now and study.score.blank?
        #caculate the final GPA
        score = caculate_score(study.id)
        study.score = score
        study.passed = score >= 95.00 ? true : false
        Study.find(study.id).update(:score => study.score, :passed => study.passed)
      end
    end
  end

  def caculate_score(study_id)
    score = 0.0
    total_exams = 0
    total_days = Study.find(study_id).course.duration_days
    exams_in_day = Array.new(total_days, 0)
    progresses = current_user.progresses.where(:study_id => study_id, :stage => 3).order("day ASC").all
    progresses.each do |pro|
      exams_in_day[pro.day - 1] = exams_in_day[pro.day - 1] + 1
      score = score + pro.score
      total_exams = total_exams + 1
    end

    exams_in_day.each do |exam|
      total_exams = total_exams + 1 if exam == 0
    end

    score = score / total_exams if total_exams > 0
    return score
  end

  def select_study
    @current_section = 'studies' 
    @ended = false
    @study = current_user.studies.where("uuid = ?", params[:uuid]).first
    #@study = current_user.studies.find(params[:id])
    # stage: 3 => exam
    # phase: start from 0, max 12, the "module"
    # GPA = SUM( SUM(scores_of_day) / module_of_day_taken ) / total_days
    #@story_records = @study.progresses.where('stage = 3').all

    @gpa = 0.0
    #@story_records.each |rec| do
    #end
    if @study.score.nil?
      @gpa = @study.progresses.where('stage = 3').select("AVG(score) AS gpa").first.gpa
    else 
      @gpa = @study.score
    end
  end
    
end
