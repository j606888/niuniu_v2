class GameService::PlayerBet < Service
  class BetAmountOverMaxError < StandardError; end

  def initialize(line_group_id:, player_id:, bet_amount:)
    @line_group_id = line_group_id
    @player_id = player_id
    @bet_amount = bet_amount
  end

  def perform
    player = Player.find_by(id: @player_id)
    line_group = LineGroup.find_by(id: @line_group_id)
    game = line_group.games.ongoing.first

    raise "Player does not belong to this line group." if player.line_group != line_group
    raise "There is no ongoing game in this line group." if game.nil?
    raise "Dealer can not bet" if game.dealer_id == player.id
    raise BetAmountOverMaxError, "bet_amount over max_bet_amount" if @bet_amount > game.max_bet_amount

    bet_record = BetRecord.find_or_initialize_by(
      game: game,
      player: player
    )
    bet_record.update!(bet_amount: @bet_amount)
    bet_record
  end
end
