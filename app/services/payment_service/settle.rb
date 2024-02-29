class PaymentService::Settle < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find(@line_group_id)
    last_game = line_group.games.last

    raise "No game found" if last_game.nil?
    raise "Last Game is not finished" if ["game_ended", "game_canceled"].exclude?(last_game.aasm_state)

    player_win_amount_map = {}
    not_bundle_games = line_group.games.where(aasm_state: 'game_ended', game_bundle_id: nil).includes(:bet_records)
    not_bundle_games.each do |game|
      game.bet_records.each do |bet_record|
        player_win_amount_map[bet_record.player_id] ||= 0
        player_win_amount_map[bet_record.player_id] += bet_record.win_amount
      end
    end

    ActiveRecord::Base.transaction do
      game_bundle = GameBundle.create!(line_group: line_group)
      not_bundle_games.each { |game| game.update!(game_bundle: game_bundle) }
      player_win_amount_map.each do |player_id, amount|
        next if amount == 0
        PaymentConfirmation.create!(game_bundle: game_bundle, player_id: player_id, amount: amount)
      end
    end
  end
end
