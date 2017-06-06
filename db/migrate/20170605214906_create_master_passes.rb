class CreateMasterPasses < ActiveRecord::Migration[5.0]
  def change
    create_table :master_passes do |t|
      t.string :password

      t.timestamps
    end
  end
end
