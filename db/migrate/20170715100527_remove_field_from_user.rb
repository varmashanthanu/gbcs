class RemoveFieldFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :program, :string
  end
end
