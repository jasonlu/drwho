class CartsController < ApplicationController
  # GET /carts
  # GET /carts.json
  before_filter :init
  before_filter :check_profile
  
  def init
    @current_section = 'account'
  end

  def index
    @carts = Cart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carts }
    end
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    #session_id = request.session_options[:id]
    session_id = cookies[:cart_id]
    @carts = Cart.where("session_id = ?", session_id)
    if @carts.blank? then
      view = 'noshow'
    else
      view = 'show'
    end
    
    respond_to do |format|
      format.html { render view }# show.html.erb
      format.json { render json: @cart }
    end
  end

  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end

  def delete
    Cart.delete(params[:id])

    redirect_to cart_path
    
  end

  # POST /cart/add
  # POST /cart/add.json
  def add
    @course = Course.find(params[:id])
    course_id = @course.id
    session_id = cookies[:cart_id].blank? ? request.session_options[:id] : cookies[:cart_id]

    Cart.where("created_at < ?", 72.hour.ago).delete_all

    if current_user.nil?
      uid = -1
    #  @cart = Cart.find_by_session_id(session_id);
    else
      uid = current_user.id
      carts = Cart.where("user_id = ?", uid).update_all(:session_id => session_id)
    #  @cart = Cart.find_by_user_id(uid);
    end
    last_cart = Cart.find_by_session_id(session_id)
    if last_cart.blank?
      order_number = Time.now.strftime("%Y%m%d%H%M%S") + session_id.to_i(16).to_s[0..2]
    else
      if last_cart.order_number.blank?
        order_number = Time.now.strftime("%Y%m%d%H%M%S") + session_id.to_i(16).to_s[0..2]
      else
        order_number = last_cart.order_number
      end
    end

    carts = Cart.where("session_id = ? AND course_id = ?", session_id, course_id)
    if carts.first.nil?
      @cart = Cart.new
      @cart.user_id = uid
      @cart.session_id = session_id
      @cart.course_id = course_id
      @cart.order_number = order_number
      @cart.save
    end

    respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: carts, status: :created }
    end
  end

end
