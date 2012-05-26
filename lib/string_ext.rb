module StringExt
  def blank?
    self.strip.empty?
  end
  
  def present?
    !blank?
  end
end

class String
  include StringExt
end
