class User < ActiveRecord::Base

  has_many :projects
  has_many :user_skills
  
end