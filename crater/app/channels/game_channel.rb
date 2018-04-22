class GameChannel < ApplicationCable::Channel
  before_subscribe :set_game
  def subscribed
    stream_from streaming_name(current_user) if @game
  end

  def unsubscribed
  end

  def put_stone(data)
    return if current_user != @game.reload.player_in_turn
    y, x = data['pos'].split(':').map(&:to_i)
    @game.put_stone(y, x)
    redraw_all
  end

  def join
    @game.join(current_user)
    redraw_all
  end

  def quit
    @game.quit(current_user)
    redraw_all
  end

private
  def streaming_name(user)
    "game_channel:#{@game.to_gid_param}:#{user.to_gid_param}"
  end

  def set_game
    @game = Game.find_by(id: params[:id])
  end

  def redraw_all
    redraw(@game.first_player)
    redraw(@game.second_player)
  end

  def redraw(user)
    return if user.nil?
    html = ApplicationController.renderer.render(
      @game,
      locals: {current_user: user}
    )
    ActionCable.server.broadcast(
      streaming_name(user),
      {
        command: 'redraw',
        game_view: html
      }
    )
  end
end
