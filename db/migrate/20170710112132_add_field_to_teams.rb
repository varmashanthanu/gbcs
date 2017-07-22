class AddFieldToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :team_skills_count, :integer, :default => 0
  end
end
