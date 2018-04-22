module GamesHelper
  def stone_view(piece, y, x, playable)
    case piece
    when nil
     playable ? "<label><input type=\"radio\" name=\"new_stone\" value=\"#{y}:#{x}\" class=\"radio\"/><span class=\"radio-icon\"></span></label>" : ''
    when 0 then '⚫️'
    when 1 then '⚪️'
    end
  end
end
