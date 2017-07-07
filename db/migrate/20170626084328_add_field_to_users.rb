class AddFieldToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :score, :integer
    add_index :users, :score
  end
end
