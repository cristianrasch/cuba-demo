class Model
  class RecordInvalid < StandardError; end
  
  def valid?; true; end
  
  def save; valid?; end
  
  def save!
    if save
      self
    else
      raise RecordInvalid
    end
  end
end
