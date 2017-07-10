class AddFieldToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :team_skills_count, :integer, :default => 0
  end
end
