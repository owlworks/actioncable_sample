class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.text :board_info
      t.integer :status, null: false, default: 0
      t.integer :first_player_id
      t.integer :second_player_id

      t.timestamps
    end
  end
end
