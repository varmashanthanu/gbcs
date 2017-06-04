class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :avatar
      t.integer :lead_id

      t.timestamps
    end
    add_index :teams, :name
  end
end
