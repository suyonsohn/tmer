class Skill < ActiveRecord::Base
  has_many :projects
  has_many :project_skills
  has_many :user_skills
end