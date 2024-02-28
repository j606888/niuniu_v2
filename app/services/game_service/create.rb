class GameService::Create < Service
  def initialize(player_id:, line_group_id:, max_bet_amount:)
    @player_id = player_id
    @line_group_id = line_group_id
    @max_bet_amount = max_bet_amount
  end

  def perform
    player = Player.find_by(id: @player_id)
    line_group = LineGroup.find_by(id: @line_group_id)

    validate_player_belong_to_line_group!(player, line_group)
    validate_none_ongoing_game!(line_group)

    game = Game.create!(
      dealer: player,
      line_group: line_group,
      max_bet_amount: @max_bet_amount
    )
    game
  end

  private

  def validate_player_belong_to_line_group!(player, line_group)
    return if player.line_group == line_group

    raise "Player does not belong to this line group."
  end

  def validate_none_ongoing_game!(line_group)
    return if line_group.games.ongoing.empty?

    raise "There is an ongoing game in this line group."
  end
end
