class CartsController < ApplicationController
  # GET /carts
  # GET /carts.json
  before_filter :init
  before_filter :check_profile
  skip_before_filter :verify_authenticity_token, :only => [:add]
  
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
    course = Course.find(params[:id])
    course_id = course.id
    cart_id = cookies[:cart_id]
    puts cookies
    #session_id = cookies[:cart_id].blank? ? request.session_options[:id] : cookies[:cart_id]
    

    # Delete expired carts
    Cart.where("created_at < ?", 72.hour.ago).delete_all
    
    @carts = nil
    # If guest
    if current_user.nil?
      uid = -1
    else # Registered user
      uid = current_user.id
      @carts = Cart.where("user_id = ?", uid).update_all(:session_id => cart_id)
    end

    # Check if the course already in cart
    last_cart = Cart.find_by_session_id(cart_id)
    order_number = ""
    if last_cart.blank? # New cart
      order_number = Time.now.strftime("%Y%m%d%H%M%S") + cart_id.to_i.to_s[0..2]
    else
      if last_cart.order_number.blank?
        order_number = Time.now.strftime("%Y%m%d%H%M%S") + cart_id.to_i.to_s[0..2]
      else
        order_number = last_cart.order_number
      end
    end

    @carts = Cart.where("session_id = ? AND course_id = ?", cart_id, course_id)
    if @carts.first.nil?
      @cart = Cart.new
      @cart.user_id = uid
      @cart.session_id = cart_id
      @cart.course_id = course_id
      @cart.order_number = order_number
      @cart.save
    end
    #render json: @carts, status: :created 
    respond_to do |format|
        format.html { render :action => "index" }
        format.json { render json: @carts, status: :created }
    end
  end

end # end of class