class Project < ActiveRecord::Base
  has_many :skills
  has_many :project_skills
  belongs_to :user
end