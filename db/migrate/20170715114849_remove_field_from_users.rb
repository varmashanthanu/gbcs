class RemoveFieldFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :users, :program, foreign_key: true
  end
end
