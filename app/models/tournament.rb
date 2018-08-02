class Tournament < ApplicationRecord
  validates :name, uniqueness: true
  has_many :players
  has_many :results

  def matches_remaining
    player_count = players.count

    player_count * (player_count - 1) / 2 - results.count
  end

  def champions
    player_count = players.count

    return [] if player_count < 2 || matches_remaining > 0

    victories_by_player = results.group(:winner_id).count
    puts victories_by_player
    max_victories = victories_by_player.values.max
    champion_ids = victories_by_player.select { |k, v| v == max_victories }.keys
    puts champion_ids
    res = Player.where(id: champion_ids).select(:slack_name).all
    puts res
    res
  end
end
