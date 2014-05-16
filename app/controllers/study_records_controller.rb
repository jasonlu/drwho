class StudyRecordsController < ApplicationController
  before_filter :set_study, :only => [:wrongs_in_course]
  before_filter :set_records, :only => [:wrongs, :wrongs_in_course]
  @current_section = 'account'
  def set_study
    @study = Study.find_by_uuid(params[:uuid])    
  end

  def set_records
    @records = current_user.study_records.wrong
  end

  def wrongs
    
  end

  def wrongs_by_course
    @records = current_user.study_records.wrong_by_course
  end

  def wrongs_in_course
    @records = @records.where(:study_id => @study.id)
  end


end
