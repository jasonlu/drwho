class SelfLearningsController < ApplicationController
  before_filter :authenticate_user!, :check_profile, :check_paid!
  before_filter :select_learning_object, :only => [:show, :exam, :exam_result, :edit]

  def select_learning_object

    @learnings = SelfLearning.where(:grouping_id => params[:grouping_id]).order("'order' ASC").all
  end

  def check_paid!
    order = current_user.user_orders.where(:payment_status => 1).first;
    render :not_paid if order.nil?
  end

  def new
    @learnings = Array.new(20)
    for i in 0..@learnings.length
      @learnings[i] = SelfLearning.new
    end
  end


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
      sort = 'created_at'
    end
    @self_learnings = current_user.self_learnings.group("grouping_id").order(sort + ' ' + dir).page(params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @self_learnings }
    end
  end

  def show
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @learnings }
    end
  end

  def exam
    
  end

  def exam_result
    @answers = Hash.new
    @correct_percentage = 0.0
    @correct_count = 0
    for i in 0..@learnings.length - 1
      
      id = @learnings[i].id
      right_answer = @learnings[i].translation
      user_answer = params[:answers][id.to_s]
      
      obj = OpenStruct.new
      obj.text = user_answer[:text]
      obj.id = user_answer[:id]
      obj.is_correct = right_answer == obj.text ? true : false
      @correct_count = @correct_count + 1 if obj.is_correct
      
      @answers[@learnings[i].id.to_s] = obj
    end
    @correct_percentage = (@correct_count / @learnings.length.to_f).round(2)

  end

  def destroy
    grouping_id = params[:grouping_id]
    current_user.self_learnings.where(:grouping_id => grouping_id).destroy_all
    redirect_to self_learnings_path
  end


  def update
    grouping_id = params[:grouping_id]
    for i in 0..params[:original].length do
      learning = Hash.new
      learning[:id] = params[:id][i]
      learning[:original] = params[:original][i]
      learning[:translation] = params[:translation][i]
      learning[:word_type] = params[:word_type][i]
      learning[:order] = params[:order][i]
      current_user.self_learnings.where(:id => params[:id][i].to_i, :grouping_id => grouping_id).update_all(learning)
    end
    redirect_to self_learning_path(grouping_id), :notice => t("update_self_learning_successful")
  end
  def create
    grouping_id = SecureRandom.uuid
    serial = SelfLearning.order("serial DESC").first.serial.to_i
    serial = serial + rand(10..50)
    for i in 0..params[:original].length
      if params[:original][i].blank?
        next
      end
      learning = Hash.new
      #learning[:user_id] = current_user.id
      learning[:grouping_id] = grouping_id
      learning[:original] = params[:original][i]
      learning[:translation] = params[:translation][i]
      learning[:word_type] = params[:word_type][i]
      learning[:order] = params[:order][i]
      learning[:serial] = serial
      current_user.self_learnings.create learning
    end
    #render :json => serial
    redirect_to self_learnings_path
  end
end
