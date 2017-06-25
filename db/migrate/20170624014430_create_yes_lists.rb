class CreateYesLists < ActiveRecord::Migration[5.0]
  def change
    create_table :yes_lists do |t|
      t.references :user
      t.references :target
      t.string :match

      t.timestamps
    end
  end
end
