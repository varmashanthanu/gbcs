class CreateCompTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :comp_teams do |t|
      t.references :competition, foreign_key: true
      t.references :team, foreign_key: true
      t.datetime :expiry

      t.timestamps
    end
  end
end
