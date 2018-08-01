class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.timestamps
      t.integer :winner_id
      t.integer :looser_id
      t.integer :tournament_id
    end

    add_foreign_key :results, :players, column: :winner_id
    add_foreign_key :results, :players, column: :looser_id
    add_foreign_key :results, :tournaments
  end
end
