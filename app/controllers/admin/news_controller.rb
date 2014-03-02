class Admin::NewsController < Admin::BackstageController
  before_action :set_admin_news, only: [:show, :edit, :update, :destroy]

  # GET /admin/news
  def index
    sort = params[:sort]
    dir = params[:dir]
    @admin_news = News.all.order(sort + ' ' + dir).page(params[:page])
  end

  # GET /admin/news/1
  def show
  end

  # GET /admin/news/new
  def new
    @admin_news = News.new
  end

  # GET /admin/news/1/edit
  def edit
  end

  # POST /admin/news
  def create
    @admin_news = News.new(admin_news_params)

    if @admin_news.save
      #redirect_to @admin_news, notice: 'News was successfully created.'
      redirect_to admin_news_index_path, notice: 'News was successfully updated.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/news/1
  def update
    if @admin_news.update!(admin_news_params)
      #render :json => {:params => admin_news_params }
      #redirect_to edit_admin_news_path, notice: 'News was successfully updated.'
      redirect_to admin_news_index_path, notice: 'News was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/news/1
  def destroy
    @admin_news.destroy
    redirect_to admin_news_index_path, notice: 'News was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_news
      @admin_news = News.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_news_params
      params[:news][:user_id] = current_user.id
      params.require(:news).permit(:id, :content, :title, :user_id, :publish_at, :close_at)
    end
end
