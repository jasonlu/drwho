class HomeController < ApplicationController
  def welcome
    File.open(File.join(Rails.root, "public", "docs", "mfg.html"), "r+") do |f|
      @mfg = f.read
    end

    @news = News.letest.limit(3)
    
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'category'
      sort = 'categories.title'
    when 'title', 'serial', 'price', 'unit'
    else
      sort = 'id'
    end

    @courses = Course.where("start_at <= ? && end_at >= ? && price > 0", Date.today, Date.today).joins(:category).order(sort + ' ' + dir).limit(10).page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end

end
