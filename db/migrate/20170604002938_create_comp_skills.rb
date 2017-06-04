class CreateCompSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :comp_skills do |t|
      t.references :competition, foreign_key: true
      t.references :skill, foreign_key: true
      t.integer :level

      t.timestamps
    end
  end
end
