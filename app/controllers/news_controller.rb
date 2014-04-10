class NewsController < ApplicationController
  # GET /news
  # GET /news.json
  def index
    @news = News.letest.page(params[:page]).per(5)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
    @news = News.find_by_title(params[:title])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news }
    end
  end


end
