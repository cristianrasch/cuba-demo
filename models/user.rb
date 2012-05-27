class User
  attr_reader :email, :password
  
  def initialize(email, password)
    @email, @password = email.to_s, password
  end
  
  def authenticated_by?(passwd)
    password == passwd
  end
  
  class << self
    def find_by_email(email)
      email.downcase!
      authorized_users.find { |user| user.email == email }
    end
    
    private
    def authorized_users
      @authorized_users ||= {"admin@example.com" => "change-me"}.map do |email, password|
        User.new email, password
      end
    end
  end
end

