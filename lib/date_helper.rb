module DateHelper
  def format_date(date)
    date.strftime "%d/%m/%Y"
  end
  
  def parse_date(day, month, year)
    begin
      Date.strptime "#{day}/#{month}/#{year}", '%d/%m/%Y'
    rescue ArgumentError; end
  end
end
