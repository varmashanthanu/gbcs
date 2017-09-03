class ChangeColumnInUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :score, :float
  end
end
