class LineMessageService::CurrentBet < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)
    game = Game.find_by(line_group: line_group, aasm_state: 'bets_opened')

    current_bets = game.bet_records.includes(:player).map do |bet_record|
      {
        type: "box",
        layout: "baseline",
        contents: [
          {
            type: "text",
            text: bet_record.player.name,
            weight: "bold",
            margin: "sm",
            flex: 3,
            contents: []
          },
          {
            type: "text",
            text: bet_record.bet_amount.to_s,
            size: "sm",
            color: "#666666",
            align: "end",
            contents: []
          }
        ]
      }
    end

    if current_bets.empty?
      {
        type: 'text',
        text: "尚無下注"
      }
    else
      flex_message(game, current_bets)
    end
  end

  private

  def flex_message(game, current_bets)
    {
      type: 'flex',
      altText: '當前下注',
      contents: {
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
                  text: "當前下注",
                  weight: "bold",
                  size: "md",
                  contents: []
                },
                {
                  type: "filler"
                },
                {
                  type: "filler"
                },
                {
                  type: "button",
                  action: {
                    type: "message",
                    label: "取消",
                    text: "CANCEL"
                  },
                  color: "#ECA1A1FF",
                  margin: "none",
                  height: "sm",
                  style: "primary"
                }
              ]
            },
            {
              type: "text",
              text: "下注上限",
              size: "xs",
              color: "#666666",
              align: "center",
              margin: "xl",
              wrap: false,
              contents: []
            },
            {
              type: "text",
              text: game.max_bet_amount.to_s,
              weight: "bold",
              size: "3xl",
              align: "center",
              margin: "xs",
              contents: []
            },
            {
              type: "separator",
              margin: "lg"
            },
            {
              type: "text",
              text: "目前下注",
              size: "xxs",
              color: "#AAAAAA",
              wrap: true,
              contents: []
            },
            {
              type: "box",
              layout: "vertical",
              spacing: "sm",
              contents: current_bets
            },
            {
              type: "separator"
            },
            {
              type: "text",
              text: "莊家",
              size: "xxs",
              color: "#AAAAAA",
              wrap: true,
              contents: []
            },
            {
              type: "button",
              action: {
                type: "message",
                label: "發牌",
                text: "GOGO"
              },
              color: "#2196F3",
              height: "sm",
              style: "primary"
            }
          ]
        }
      }
    }
  end
end
