class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :url
      t.datetime :start
      t.integer :duration
      t.string :type
      t.string :description
      t.string :prize
      t.string :host
      t.integer :creator_id

      t.timestamps
    end
    add_index :competitions, :name
  end
end
