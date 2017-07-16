class AddFieldToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :term, :string
  end
end
