class PlayerService::TotalWinAmount < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find(@line_group_id)

    result = BetRecord.joins(:game).includes(:player)
      .select('bet_records.player_id, SUM(bet_records.win_amount) AS total_win_amount')
      .where(games: { line_group_id: line_group.id, aasm_state: 'game_ended' })
      .group('bet_records.player_id')
      .order('total_win_amount DESC')

    result.map do |record|
      player = record.player
      {
        player_id: player.id,
        name: player.name,
        total_win_amount: record.total_win_amount
      }
    end
  end
end


# PlayerService::OverallWinAmount.call(line_group_id: 2)
