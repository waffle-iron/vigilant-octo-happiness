class CreateGiversReceiversJoinTable < ActiveRecord::Migration
  def change
    create_join_table :givers, :receivers do |t|
      t.index :giver_id
      t.index :receiver_id
      t.references :list, null: false
      t.timestamps null: false
    end
  end
end
