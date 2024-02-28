class GameService::Battle < Service
  def initialize(dealer_id:, line_group_id:)
    @dealer_id = dealer_id
    @line_group_id = line_group_id
  end

  def perform
    dealer = Player.find_by(id: @dealer_id)
    line_group = LineGroup.find_by(id: @line_group_id)
    game = Game.find_by(line_group: line_group, aasm_state: "bets_locked")

    raise "There is no ongoing game in this line group." if game.nil?
    raise "Player does not belong to this line group." if dealer.line_group != line_group
    raise "Player is not dealer" if game.dealer != dealer

    game.start_battle!

    dealer_hand = Poker::DealerHand.new(player_id: dealer.id)
    player_hands = game.bet_records.map do |bet_record|
      Poker::PlayerHand.new(
        player_id: bet_record.player.id,
        bet_amount: bet_record.bet_amount
      )
    end
    Poker::StartGame.call(
      dealer_hand: dealer_hand,
      player_hands: player_hands
    )
    ActiveRecord::Base.transaction do
      BetRecord.create!(game: game, player: dealer, cards: dealer_hand.cards, win_amount: dealer_hand.win_lose_amount, score: dealer_hand.score)
      player_hands.each do |player_hand|
        bet_record = game.bet_records.find { |bet_record| bet_record.player_id == player_hand.player_id }
        bet_record.update!(cards: player_hand.cards, win_amount: player_hand.win_lose_amount, score: player_hand.score)
      end
    end

    game.end_game!
    game
  end
end
