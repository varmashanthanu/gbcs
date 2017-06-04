class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :group
      t.integer :weight

      t.timestamps
    end
    add_index :skills, :name
    add_index :skills, :group
  end
end
