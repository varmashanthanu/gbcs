class CreateTeamSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :team_skills do |t|
      t.references :skill, foreign_key: true
      t.references :team, foreign_key: true
      t.integer :level

      t.timestamps
    end
  end
end
