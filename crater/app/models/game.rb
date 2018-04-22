class Game < ApplicationRecord
  serialize :board_info, JSON
  after_create :set_board

  enum status: {
    open: 0,
    playing: 1,
    closed: 2
  }

  def player_in_turn
    return unless playing?
    self.board_info['turn'].to_i.odd? ? first_player : second_player
  end

  def current_stone
    self.board_info['turn'].to_i.odd? ? 0 : 1
  end

  def first_player
    User.find_by(id: first_player_id)
  end

  def second_player
    User.find_by(id: second_player_id)
  end

  def join(user)
    return if [first_player_id, second_player_id].all?(&:present?) || joined?(user)
    # 先にjoinした方が先手になる
    if first_player_id.blank?
      update(first_player_id: user.id)
    else
      update(second_player_id: user.id)
    end
    update(status: :playing) if [first_player_id, second_player_id].all?(&:present?)
  end

  def put_stone(y, x)
    # 周辺8方向
    directions = ([*-1..1].product [*-1..1]) - [[0, 0]]
    # 周辺の石を反転
    directions.each do |dy, dx|
      # 盤面の範囲外なら無視
      next unless [dy + y, dx + x].all? { |pos| pos.between?(0, 7)}
      stone = self.board_info['board'][dy + y][dx + x]
      # 石がなければ無視
      next if stone.nil?
      self.board_info['board'][dy + y][dx + x] = (stone == 0 ? 1 : 0)
    end

    self.board_info['board'][y][x] = current_stone
    self.board_info['turn'] += 1
    self.status = :closed if is_end?
    save
  end

  def quit(user)
    if first_player_id == user.id
      update(first_player_id: nil)
    end

    if second_player_id == user.id
      update(second_player_id: nil)
    end
    update(status: :closed) unless [first_player_id, second_player_id].all?(&:present?)
  end

  def joined?(user)
    [first_player_id, second_player_id].include?(user.id)
  end

  private

  def set_board
    board = Array.new(8) { Array.new(8) }

    # 初期配置の４コマを設定
    board[2][2] = 0
    board[5][5] = 0
    board[2][5] = 1
    board[5][2] = 1

    update(board_info: { board: board, turn: 1 })
  end

  def is_end?

  end
end
