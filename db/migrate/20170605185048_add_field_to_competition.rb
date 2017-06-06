class AddFieldToCompetition < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :comp_type, :string
  end
end
