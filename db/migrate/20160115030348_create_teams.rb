class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :user_id
      t.integer :monsters_count, default: 0

      t.timestamps null: false
    end
    add_index :teams, :user_id
    add_column :users, :teams_count, :integer, default: 0
  end
end
