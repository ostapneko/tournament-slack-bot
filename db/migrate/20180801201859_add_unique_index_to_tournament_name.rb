class AddUniqueIndexToTournamentName < ActiveRecord::Migration[5.2]
  def change
    add_index :tournaments, :name, unique: true
  end
end
