class Poker::DealerHand < Poker::HandBase
  def calculate_win_lose_amount(player_hands)
    @win_lose_amount = player_hands.map(&:win_lose_amount).sum * -1
  end
end
