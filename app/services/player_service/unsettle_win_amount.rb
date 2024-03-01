class PlayerService::UnsettleWinAmount < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find(@line_group_id)
    player_win_amount_map = {}

    not_bundle_games = line_group.games.where(aasm_state: 'game_ended', game_bundle_id: nil).includes(:bet_records)
    not_bundle_games.each do |game|
      game.bet_records.each do |bet_record|
        player_win_amount_map[bet_record.player_id] ||= 0
        player_win_amount_map[bet_record.player_id] += bet_record.win_amount
      end
    end

    player_win_amount_map
  end
end
