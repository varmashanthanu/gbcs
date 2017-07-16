class RemoveFieldFromPrograms < ActiveRecord::Migration[5.0]
  def change
    remove_column :programs, :term, :string
  end
end
