class Project < ActiveRecord::Base
  has_many :skills, through: :project_skills
  has_many :project_skills
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
end