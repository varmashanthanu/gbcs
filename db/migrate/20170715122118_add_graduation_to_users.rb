class AddGraduationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :graduation, :integer
  end
end
