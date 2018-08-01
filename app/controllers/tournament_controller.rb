class TournamentController < ApplicationController
  def handle
    case params['text']
    when 'help'
      answer_text <<-EOM
create <tournament-name>: create a new tournament
show: show all the tournaments
      EOM
    when /^create (\S+)$/
      create_tournament $1
    when /^show$/
      answer_text get_tournament_names
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
    Tournament.select(:name).map(&:name).join("\n")
  end
end
