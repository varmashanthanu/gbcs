class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :sender_id

      t.timestamps
    end
  end
end
