class TournamentController < ApplicationController
  def handle
    case params['text']
    when 'help'
      answer_text <<-EOM
create <tournament-name>: create a new tournament
show: show all the tournaments
add <player> to <tournament>
<winner> beat <looser> in <tournament>
      EOM
    when /^create (\S+)$/
      create_tournament $1
    when /^show$/
      answer_text get_tournament_names
    when /^add (\S+) to (\S+)$/
      add_player $1, $2
    when /^(\S+) beat (\S+) in (\S+)$/
      add_result($1, $2, $3)
    else
      answer_text "What is this command?"
    end
  end

  private

  def answer_text(s)
    render json: { text: s }
  end

  def create_tournament(name)
      t = Tournament.create(name: name)
      if t.valid?
        answer_text "Created #{name} tournament!"
      else
        answer_text "Invalid creation: #{t.errors.full_messages.join(', ')}"
      end
  end

  def get_tournament_names
    Tournament
      .includes(:players)
      .map do |t|
      champions = t.champions
        status =
          if champions.any?
            "won by #{champions.map(&:slack_name).join(', ')}"
          elsif
            t.players.count < 2
            "not enough players"
          else
            "#{t.matches_remaining} matches to go"
          end

        t.name + " (#{status}): " + t.players.map(&:slack_name).join(', ')
      end.join("\n")
  end

  def add_player(player, tournament_name)
    t = Tournament.find_by_name(tournament_name)
    if t
      p = Player.create(slack_name: player, tournament_id: t.id)
      if p.valid?
        answer_text "Added #{player} to #{tournament_name}"
      else
        answer_text "Could not add #{player} to #{tournament_name}: #{p.errors.full_messages.join(', ')}"
      end
    else
      answer_text "#{tournament_name} does not exist"
    end
  end

  def add_result(winner_name, looser_name, tournament_name)
    t = Tournament.find_by_name!(tournament_name)
    w = Player.find_by!(slack_name: winner_name, tournament_id: t.id)
    l = Player.find_by!(slack_name: looser_name, tournament_id: t.id)

    r1 = Result.find_by(
      winner_id: w.id,
      looser_id: l.id,
      tournament_id: t.id
    )

    r2 = Result.find_by(
      winner_id: l.id,
      looser_id: w.id,
      tournament_id: t.id
    )

    if r1 || r2
      answer_text "This match has already been played!"
    else
      Result.create!(
        winner_id: w.id,
        looser_id: l.id,
        tournament_id: t.id
      )

      result = "Congrats #{winner_name}!"
      winners = t.champions.map(&:slack_name).join(', ')

      if t.champions.any?
        result << "\nThe tournament has ended!\nCongrats to #{winners} for winning the tournament!"
      end

      answer_text result
    end

  rescue ActiveRecord::RecordNotFound => e
    answer_text "Invalid match. #{e.message}"
  end
end
