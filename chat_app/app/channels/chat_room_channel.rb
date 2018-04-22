class ChatRoomChannel < ApplicationCable::Channel
def subscribed
  stream_from "chat_room_channel_#{params[:id]}"
  post_message({"message" => "誰かが来ました"})
end

def unsubscribed
  post_message({'message' => '誰かが帰りました'})
end

  def post_message(data)
    id = params[:id]
    message = data['message']
    if ChatMessage.create(chat_room_id: id, body: message)
      ActionCable.server.broadcast "chat_room_channel_#{id}", message_html: "<p>#{ message }</p>"
    else
      # 例外処理
    end
  end
end
