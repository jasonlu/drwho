class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  def index
    sort = params[:sort]
    dir = params[:dir]

    case sort
    when 'category'
      sort = 'categories.title'
    when 'title', 'serial', 'price', 'unit'
    else
      sort = 'id'
    end
    
    @courses = Course.where("start_at <= ? && end_at >= ? && price > 0", Date.today, Date.today).joins(:category).order(sort + ' ' + dir).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

end
