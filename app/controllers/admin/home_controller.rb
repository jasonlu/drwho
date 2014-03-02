class Admin::HomeController < Admin::BackstageController

  def dashboard
    
  end

  def edit
    File.open(File.join(Rails.root, "doc", "mfg.html"), "r+") do |f|
      @mfg = f.read
    end

  end

  def update

    File.open(File.join(Rails.root, "doc", "mfg.html"), "w") do |f|
      f.write(params[:content])
    end
    redirect_to :back
  end

end
