class MyAccountController < ApplicationController
  
  before_filter :authenticate_user!

  def profile
  end

  def cart
  end

  def receipt
  end

  def choose_start_day
  end

  def study_record
  end

  def self_learning
  end

  def news
  end

  def logout
  end

  def calendar
    @studies = Study.where("user_id = ?", current_user.id)
    
  end
end
