class UserOrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!


  # GET /user_orders
  # GET /user_orders.json
  def index
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'price'
      sort = 'payment_price'
    when 'order_number', 'id', 'price', 'created_at', 'payment_status'
    else
      sort = 'order_number'
    end
    

    #@user_orders = current_user.user_orders.all.page(params[:page])
    @user_orders = UserOrder.where('user_id = ?', current_user.id).order(sort + ' ' + dir).page(params[:page])
    @current_section = 'account'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_orders }
    end
  end

  # GET /user_orders/1
  # GET /user_orders/1.json
  def show

    

    @user_order = UserOrder.where('order_number = ? AND user_id = ?', params[:order_number], current_user.id).first
    @order_number = params[:order_number]
    @courses = Course.find(@user_order.courses.split(','))
    respond_to do |format|
      format.html {
        if params[:mode] == 'print'
          render layout: 'printer', template: 'user_orders/print'
        end
      } 
      format.json { render json: @user_order }
    end
  end

  def new
    order_number = params[:order_number]
    session_id = cookies[:cart_id]
    carts = Cart.where("session_id = ?", session_id)
    if carts.length == 0
      return redirect_to user_order_path(order_number)
    else
      courses_array = Array.new
      price = 0
      carts.each do |cart|
        price = price + cart.course.price
        courses_array.push(cart.course_id)
      end
      Cart.where("session_id = ?", session_id).delete_all

      courses = courses_array.join(",")

      @user_order = UserOrder.find_by_order_number(order_number)

      if @user_order.blank?
        @user_order = UserOrder.new
        @user_order.user_id = current_user.id
        @user_order.payment_status = 0
        @user_order.payment_method = 0
        @user_order.payment_price = price
        @user_order.courses = courses
        @user_order.order_number = order_number
        @user_order.save!
      end
    end

    @courses = Course.find(courses_array)
    return redirect_to user_order_path(order_number)
    
    #render :template => 'show'
    #respond_to do |format|
    #  format.html { render :template => 'show' }
    #  format.json { render json: @user_order }
    #end
  end

  # DELETE /user_orders/1
  # DELETE /user_orders/1.json
  def destroy
    @user_order = UserOrder.find(params[:id])
    @user_order.destroy

    respond_to do |format|
      format.html { redirect_to user_orders_url }
      format.json { head :no_content }
    end
  end

  def set_start_day
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
    @studies = current_user.studies.where("starts_at > ? OR starts_at IS NULL", Date.today).joins(:user_order).joins(:course).joins(:category).order(sort + ' ' + dir).page(params[:page])
    #@studies = current_user.studies.joins(:user_order).joins(:course).joins(:category).order(sort + ' ' + dir).page(params[:page])
    #@orders = UserOrder.where('user_id = ? AND payment_status = 1', current_user.id)
    #@course_ids = Array.new
    #@orders.each do |order|
    #  @course_ids.concat(order.courses.split(','))
    #end
    
    #@courses = Course.where(:id => @course_ids)

  

  end
end
