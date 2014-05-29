class Project < ActiveRecord::Base
  has_many :skills, through: :project_skills
  has_many :project_skills
  belongs_to :user
end