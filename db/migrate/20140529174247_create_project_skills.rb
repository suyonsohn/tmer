class CreateProjectSkills < ActiveRecord::Migration
  def change
    create_table :project_skills do |t|
      t.integer :project_id
      t.integer :skill_id
      t.timestamps
    end
  end
end
