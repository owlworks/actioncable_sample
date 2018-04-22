App.chat_room = App.cable.subscriptions.create { channel: "ChatRoomChannel", id: gon.room_id},
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').prepend(data['message_html'])

  alert: (data) ->
    # Called when there's incoming data on the websocket for this channel
    alert(data['message_html'])

  post_message: (text) ->
    @perform 'post_message', { message: text }
