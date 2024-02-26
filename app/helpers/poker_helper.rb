# | 牌面   | A  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | J  | Q  | K  |
# |-------|----|----|----|----|----|----|----|----|----|----|----|----|----|
# | 黑桃 ♠️ | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 | 13 |
# | 紅心 ♥️ | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 |
# | 方塊 ♦️ | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36 | 37 | 38 | 39 |
# | 梅花 ♣️ | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 | 51 | 52 |

module PokerHelper
  class << self
    def card_value(card_number)
      value = ( card_number - 1 ) % 13 + 1
      value > 10 ? 10 : value
    end

    def readable_card(card_number)
      suits = ["♠️", "♥️", "♦️", "♣️"]
      values = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

      suit_index = (card_number - 1) / 13
      value_index = (card_number - 1) % 13

      "#{suits[suit_index]} #{values[value_index]}"
    end

    def calculate_odd(scores)
      return 3 if scores.include?(10)
      return 2 if scores.include?(9)
      return 2 if scores.include?(8)

      1
    end
  end
end
