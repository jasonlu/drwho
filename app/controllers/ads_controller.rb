class AdsController < ApplicationController
  before_action :set_ad, only: [:show, :go]
  
  def show
  end

  def go
    @ad.click_records.create(:referer => request.referer, :from => request.remote_ip, :url => @ad.link)
    redirect_to @ad.link
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad
      @ad = Ad.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ad_params
      
      params.require(:ad).permit(:content, :weight, :link, :counter, :location)
    end
end
