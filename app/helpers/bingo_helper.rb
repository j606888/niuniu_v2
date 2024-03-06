module BingoHelper
  DEFAULT_MAX_BET_AMOUNT = 100

  class << self
    def bingo_time?
      timezone = ActiveSupport::TimeZone["Asia/Taipei"]

      current_time = Time.now.in_time_zone(timezone)

      start_time = current_time.change(hour: 23, min: 30)
      end_time = current_time.change(hour: 23, min: 59, sec: 59)

      current_time.between?(start_time, end_time)
    end

    def max_bet_amount
      bingo_time? ? DEFAULT_MAX_BET_AMOUNT * 2 : DEFAULT_MAX_BET_AMOUNT
    end
  end
end
