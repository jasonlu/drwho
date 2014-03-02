class ClickRecordsController < ApplicationController
  before_action :set_click_record, only: [:show, :edit, :update, :destroy]

  # GET /click_records
  def index
    @click_records = ClickRecord.all
  end

  # GET /click_records/1
  def show
  end

  # GET /click_records/new
  def new
    @click_record = ClickRecord.new
  end

  # GET /click_records/1/edit
  def edit
  end

  # POST /click_records
  def create
    @click_record = ClickRecord.new(click_record_params)

    if @click_record.save
      redirect_to @click_record, notice: 'Click record was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /click_records/1
  def update
    if @click_record.update(click_record_params)
      redirect_to @click_record, notice: 'Click record was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /click_records/1
  def destroy
    @click_record.destroy
    redirect_to click_records_url, notice: 'Click record was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_click_record
      @click_record = ClickRecord.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def click_record_params
      params.require(:click_record).permit(:url, :from, :ad_id, :referer)
    end
end
