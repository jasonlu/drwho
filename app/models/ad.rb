class Ad < ActiveRecord::Base
  attr_accessible :content, :weight, :link, :counter, :location
  has_many :click_records

  def link_tag
    ActionController::Base.helpers.link_to self.content.html_safe, Rails.application.routes.url_helpers.portal_path(self.id), :target => '_blank'
  end

  def self.blank
    self.new(:content => '', :link => '', :location => -1)
  end

  def click_count
    self.click_records.all.length
  end

  def self.top_left
    self.where('location = 0').order('weight DESC').first
  end
  
  def self.top_right
    self.where('location = 1').order('weight DESC').first
  end

  def self.left
    self.where('location = 2').order('weight DESC').first
  end

  def self.right
    self.where('location = 3').order('weight DESC').first
  end

  def location_text
    case self.location
    when 0
      return '上1'
    when 1
      return '上2'
    when 2
      return '左方'
    when 3
      return '右方'
    when 4
      return '置頂'
    end
  end
end
