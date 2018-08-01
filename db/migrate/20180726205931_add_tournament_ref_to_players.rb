class AddTournamentRefToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_reference :players, :tournament, foreign_key: true
  end
end
