class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name, limit: 100
      t.string :power, limit: 100
      t.string :category, limit: 20 #used category instead of type as its reserved for STI
      t.integer :user_id
      t.integer :team_id

      t.timestamps null: false
    end
    add_index :monsters, :user_id
    add_column :users, :monsters_count, :integer, default: 0
  end
end
