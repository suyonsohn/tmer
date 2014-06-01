
class User < ActiveRecord::Base
  has_many :projects
  has_many :user_skills  
  has_many :skills, through: :user_skills

  validates :email, presence: true
  validates :email, uniqueness: true 
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true
  # validates :git_username, presence: true

  def picture
    url = 'https://github.com/' << self.git_username
    doc = Nokogiri::HTML(open(url))
    doc.search('.avatar').attr('src')
  end
  
end