module ApplicationHelper
  def fix_404
    controllers = Dir.glob("#{Rails.root}/app/controllers/*.rb")
    controllers.each do |ctrl|
      start = ctrl.rindex(/\//) + 1
      length = ctrl.rindex(/_/) - 1
      name = ctrl[start..length]
      if Dir.glob("#{Rails.root}/app/assets/javascripts/#{name}.*").empty?
        puts "MISSING: #{name}.js \n"
        File.open("#{Rails.root}/app/assets/javascripts/#{name}.js", 'w') do |f|
          f.write("// empty js file")
        end
      end

      if Dir.glob("#{Rails.root}/app/assets/stylesheets/#{name}.*").empty?
        puts "MISSING: #{name}.css \n"
        File.open("#{Rails.root}/app/assets/stylesheets/#{name}.css", 'w') do |f|
          f.write("/* empty css file */")
        end
      end
    end
  end
end

class Integer


  def to_chinese
    number_to_chinese(self)
  end

private
  def number_to_chinese(n)
    if n < 11
      case n
        when 0
          '零'
        when 1
          'ㄧ'
        when 2
          '二'
        when 3
          '三'
        when 4
          '四'
        when 5
          '五'
        when 6
          '六'
        when 7
          '七'
        when 8
          '八'
        when 9
          '九'
        when 10
          '十'
      end
    elsif n >= 11
      
      return '十' + number_to_chinese(n % 10) if n < 20
      


      if(n % 10 != 0)
        number_to_chinese(n / 10) + '十' + number_to_chinese(n % 10)
      
      else
        number_to_chinese(n / 10) + '十'
      end
    elsif n >= 101
      number_to_chinese(n / 100) + '百' + number_to_chinese(n % 100)
    end
  end
end
