class ChangeColumnNameInSkill < ActiveRecord::Migration[5.0]
  def change
    rename_column :skills, :group, :category
  end
end
