class RemoveFieldFromCompetition < ActiveRecord::Migration[5.0]
  def change
    remove_column :competitions, :type, :string
  end
end
