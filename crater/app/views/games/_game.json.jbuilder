json.extract! game, :id, :name, :board_info, :status, :first_player, :second_player, :created_at, :updated_at
json.url game_url(game, format: :json)
