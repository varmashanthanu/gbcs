class AddProgramToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :program, :string
  end
end
