module ApplicationHelper
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
