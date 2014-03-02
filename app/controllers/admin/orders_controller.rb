class Admin::OrdersController < Admin::BackstageController
  before_action :set_admin_order, only: [:show, :edit, :update, :destroy]

  # GET /admin/orders
  def index
    
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'fullname'
      sort = 'user_profiles.lasttname'
    when 'payment_status', 'payment_price', 'order_number'
    else
      sort = 'id'
    end

    @admin_orders = UserOrder.where.not(:payment_method => -1).order(sort + ' ' + dir).page(params[:page])
  end

  # GET /admin/orders/1
  def show
  end

  # GET /admin/orders/new
  def new
    @admin_order = UserOrder.new
  end

  # GET /admin/orders/1/edit
  def edit
  end

  # POST /admin/orders
  def create
    @admin_order = UserOrder.new(admin_order_params)

    if @admin_order.save
      redirect_to @admin_order, notice: 'Order was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/orders/1
  def update
    if @admin_order.update(admin_order_params)
      make_paid(@admin_order.id) if @admin_order.payment_status == 1

      redirect_to edit_admin_order_path(@admin_order), notice: 'Order was successfully updated.'
    else
      #render action: 'edit'
    end
  end

  # PATCH/PUT /admin/orders/1
  def quickpaid
    id = params[:id]
    @admin_order = UserOrder.find(id)
    if @admin_order.update_attribute(:payment_status, 1)
      make_paid(id)
      redirect_to admin_orders_path, notice: 'Order was successfully updated.'
    else
      #render action: 'edit'
    end
  end

  # DELETE /admin/orders/1
  def destroy
    @admin_order.destroy
    redirect_to admin_orders_url, notice: 'Order was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_order
      @admin_order = UserOrder.find(params[:id])
      @user = @admin_order.user
      @courses = Course.find(@admin_order.courses.split(','))
    end

    # Only allow a trusted parameter "white list" through.
    def admin_order_params
      params.require(:user_order).permit(:payment_status, :payment_price, :note)
    end

    def make_paid(order_id)
      order = UserOrder.find(order_id)
      user_id = order.user_id
      courses = order.course_list

      courses.each do |course|
        study = Study.create(:user_id => user_id, :user_order_id => order_id, :course_id => course.id)
      end

    end

end
