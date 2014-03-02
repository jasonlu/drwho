class AjaxController < ApplicationController

	def add_to_cart
		respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

end
