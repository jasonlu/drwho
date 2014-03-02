class PagesController < ApplicationController

  # GET /pages/1
  # GET /pages/1.json
  def show
    @current_section = 'pages_' + params[:id]
    @page = Page.find_by_key(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

end
