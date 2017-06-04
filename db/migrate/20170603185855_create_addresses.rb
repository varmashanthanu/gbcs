class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :addr
      t.string :addressable_type
      t.integer :addressable_id
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :addresses, :addr
  end
end
