class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :avatar
      t.integer :lead_id

      t.timestamps
    end
    add_index :users, :name
  end
end
