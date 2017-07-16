class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :program, foreign_key: true
    add_column :users, :term, :string
  end
end
