class AddFieldToTeamSkill < ActiveRecord::Migration[5.0]
  def change
    add_column :team_skills, :count, :integer, default: 0
  end
end
