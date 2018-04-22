class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.string :body
      t.string :chat_room_id
      t.string :integer

      t.timestamps
    end
  end
end
