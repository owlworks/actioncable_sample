App.game = App.cable.subscriptions.create {
    channel: "GameChannel",
    id: gon.game_id
  },
  connected: ->

  disconnected: ->

  received: (data) ->
    switch data["command"]
      when "redraw"
        document.getElementById("game_view").innerHTML = data["game_view"]
      when "result"
        alert(data["message"])

  put_stone: (pos) ->
    @perform 'put_stone', { pos: pos }

  join: ->
    @perform 'join'

  quit: ->
    @perform 'quit'
