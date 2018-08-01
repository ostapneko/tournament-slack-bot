class TournamentController < ApplicationController
  def handle
    case params['text']
    when 'help'
      answer_text <<-EOM
create <tournament-name>: create a new tournament
show: show all the tournaments
add <player> to <tournament>
      EOM
    when /^create (\S+)$/
      create_tournament $1
    when /^show$/
      answer_text get_tournament_names
    when /^add (\S+) to (\S+)$/
      add_player $1, $2
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
        t.name + ": " + t.players.map(&:slack_name).join(', ')
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
end
