class UserSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  validates :skill_id, presence: true
  validates :user_id, presence: true
end