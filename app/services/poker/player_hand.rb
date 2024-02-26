class Poker::PlayerHand < Poker::HandBase
  attr_reader :bet_amount

  def initialize(bet_amount: 0)
    @bet_amount = bet_amount
    @cards = []
    @win_lose_amount = nil
  end

  def battle(other_player_score)
    @win_lose_amount = if score == other_player_score
      0
    else
      odds = PokerHelper.calculate_odd([score, other_player_score])
      win = score > other_player_score ? 1 : -1
      @bet_amount * odds * win
    end
  end
end
