class GameService::Lock < Service
  def initialize(player_id:, line_group_id:)
    @player_id = player_id
    @line_group_id = line_group_id
  end

  def perform
    player = Player.find_by(id: @player_id)
    line_group = LineGroup.find_by(id: @line_group_id)
    game = Game.find_by(line_group: line_group, aasm_state: "bets_opened")

    raise "There is no ongoing game in this line group." if game.nil?
    raise "Player does not belong to this line group." if player.line_group != line_group
    raise "Player is not dealer" if game.dealer != player

    validate_at_least_one_bet!(game)
    game.lock_bets!
  end

  private

  def validate_at_least_one_bet!(game)
    return if game.bet_records.count >= 1

    raise "At least one bet are required to start the game."
  end
end
