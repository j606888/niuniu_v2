class GameService::Cancel < Service
  def initialize(player_id:, line_group_id:)
    @player_id = player_id
    @line_group_id = line_group_id
  end

  def perform
    player = Player.find_by(id: @player_id)
    line_group = LineGroup.find_by(id: @line_group_id)
    game = Game.find_by(line_group: line_group, aasm_state: ["bets_opened", "bets_locked"])

    raise "There is no ongoing game in this line group." if game.nil?
    raise "Player does not belong to this line group." if player.line_group != line_group

    game.cancel_game!
    game
  end
end
