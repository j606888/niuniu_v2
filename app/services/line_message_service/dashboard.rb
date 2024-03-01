class LineMessageService::Dashboard < Service
  def initialize(line_group_id:, with_game_result: false)
    @line_group_id = line_group_id
    @with_game_result = with_game_result
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)

    score_map = calculate_scores(line_group)
    score_array = sort_scores(score_map)
    players_map = line_group.players.index_by(&:id)

    unpaid_bundles = line_group.game_bundles.where(aasm_state: 'created')

    if @with_game_result
      game_result = LineMessageService::GameResult.call(line_group_id: @line_group_id)
    else
      game_result = nil
    end

    flex_message(score_array, players_map, unpaid_bundles, game_result)
  end

  private

  def calculate_scores(line_group)
    score_map = {}
    Game.where(line_group: line_group, aasm_state: 'game_ended', game_bundle_id: nil).includes(:bet_records).each do |game|
      game.bet_records.each do |bet_record|
        score_map[bet_record.player_id] ||= 0
        score_map[bet_record.player_id] += bet_record.win_amount
      end
    end

    score_map
  end

  def sort_scores(score_map)
    score_map.to_a.sort_by { |_player_id, score| -score }
  end

  def flex_message(score_array, players_map, unpaid_bundles = [], game_result = nil)
    bundle_messages = unpaid_bundles.map { |unpaid_bundle| LineMessageService::UnpaidBundle.call(game_bundle_id: unpaid_bundle.id) }
    if score_array.empty?
      contents = [
        {
          type: "box",
          layout: "baseline",
          contents: [
            {
              type: "text",
              text: "目前沒有積分",
              weight: "bold",
              margin: "sm",
              contents: []
            }
          ]
        }
      ]
    else
      contents = score_array.map do |player_id, score|
        player = players_map[player_id]
        {
          type: "box",
          layout: "baseline",
          contents: [
            {
              type: "text",
              text: player.name,
              weight: "bold",
              flex: 2,
              margin: "sm",
              contents: []
            },
            {
              type: "text",
              text: score.to_s,
              size: "sm",
              color: "#666666",
              align: "end",
              contents: []
            }
          ]
        }
      end
    end

    {
      type: 'flex',
      altText: '呼叫主選單',
      contents: {
        type: 'carousel',
        contents: [
          game_result,
          {
            type: "bubble",
            body: {
              type: "box",
              layout: "vertical",
              spacing: "md",
              action: {
                type: "uri",
                label: "Action",
                uri: "https://linecorp.com"
              },
              contents: [
                {
                  type: "box",
                  layout: "horizontal",
                  contents: [
                    {
                      type: "text",
                      text: "四七小老二",
                      weight: "bold",
                      size: "md",
                      flex: 2,
                      contents: []
                    },
                    {
                      type: "button",
                      action: {
                        type: "message",
                        label: "結算",
                        text: "SETTLE"
                      },
                      color: "#ECA1A1",
                      height: "sm",
                      style: "primary"
                    }
                  ]
                },
                {
                  type: "separator",
                  margin: "lg"
                },
                {
                  type: "text",
                  text: "目前積分",
                  size: "xxs",
                  color: "#AAAAAA",
                  wrap: true,
                  contents: []
                },
                {
                  type: "box",
                  layout: "vertical",
                  spacing: "sm",
                  contents: contents
                },
                {
                  type: "separator"
                },
                {
                  type: "text",
                  text: "新遊戲(莊家按 or 輸入上限金額)",
                  size: "xxs",
                  color: "#AAAAAA",
                  wrap: true,
                  contents: []
                },
                {
                  type: "box",
                  layout: "horizontal",
                  spacing: "md",
                  margin: "md",
                  contents: [
                    {
                      type: "button",
                      action: {
                        type: "message",
                        label: "30",
                        text: "30"
                      },
                      color: "#2196F3",
                      height: "sm",
                      style: "primary"
                    },
                    {
                      type: "button",
                      action: {
                        type: "message",
                        label: "50",
                        text: "50"
                      },
                      color: "#2196F3",
                      height: "sm",
                      style: "primary"
                    },
                    {
                      type: "button",
                      action: {
                        type: "message",
                        label: "100",
                        text: "100"
                      },
                      color: "#2196F3",
                      height: "sm",
                      style: "primary"
                    }
                  ]
                }
              ]
            }
          }
        ].compact + bundle_messages
      }
    }
  end
end
