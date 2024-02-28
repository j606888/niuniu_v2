class LineMessageService::Bet < Service
  def initialize(player_id:, bet_amount:)
    @player_id = player_id
    @bet_amount = bet_amount
  end

  def perform
    player = Player.find_by(id: @player_id)

    {
      type: 'text',
      text: "#{player.name} 下注 #{@bet_amount}"
    }
  end
end
