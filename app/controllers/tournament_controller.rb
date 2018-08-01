class TournamentController < ApplicationController
  def handle
    case params['text']
    when 'help'
      answer_text <<-EOM
create <tournament-name>
      EOM
    when /^create (\S+)$/
      create_tournament $1
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
end
