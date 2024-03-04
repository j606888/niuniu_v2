# danger zone!

class GameService::ResetLineGroup < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)
    line_group.game_bundles.includes(:payment_confirmations).each do |game_bundle|
      game_bundle.payment_confirmations.each(&:destroy)
      game_bundle.destroy
    end

    line_group.games.includes(:bet_records).each do |game|
      game.bet_records.each(&:destroy)
      game.destroy
    end
  end
end
