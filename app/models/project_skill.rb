class ProjectSkill < ActiveRecord::Base
  belongs_to :project
  belongs_to :skill

  validates :skill_id, presence: true
  validates :project_id, presence: true
end