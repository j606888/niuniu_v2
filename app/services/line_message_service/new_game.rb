class LineMessageService::NewGame < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)
    game = Game.find_by(line_group: line_group, aasm_state: 'bets_opened')
    dealer = game.dealer
    flex_message(game, dealer)
  end

  private

  def flex_message(game, dealer)
    {
      type: 'flex',
      altText: "#{dealer.name}開局啦，上限#{game.max_bet_amount}",
      contents: {
        type: "bubble",
        body: {
          type: "box",
          layout: "vertical",
          spacing: "md",
          contents: [
            {
              type: "box",
              layout: "horizontal",
              contents: [
                {
                  type: "text",
                  text: "莊家 - #{dealer.name}",
                  weight: "bold",
                  size: "md",
                  flex: 2,
                  gravity: "center",
                  contents: []
                },
                {
                  type: "button",
                  action: {
                    type: "message",
                    label: "取消",
                    text: "EXIT"
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
              text: "莊家",
              size: "xxs",
              color: "#AAAAAA",
              wrap: true,
              contents: []
            },
            {
              type: "box",
              layout: "horizontal",
              spacing: "md",
              contents: [
                {
                  type: "button",
                  action: {
                    type: "message",
                    label: "當前下注",
                    text: "NOW"
                  },
                  color: "#81D4FA",
                  height: "sm",
                  style: "primary"
                },
                {
                  type: "button",
                  action: {
                    type: "message",
                    label: "發牌",
                    text: "GO"
                  },
                  color: "#2196F3",
                  height: "sm",
                  style: "primary"
                },
              ]
            },
            {
              type: "separator"
            },
            {
              type: "text",
              text: "玩家(直接輸入金額)",
              size: "xxs",
              color: "#AAAAAA",
              wrap: true,
              contents: []
            },
            {
              type: "button",
              action: {
                type: "message",
                label: "最大金額",
                text: game.max_bet_amount.to_s
              },
              color: "#81D4FA",
              height: "sm",
              style: "primary"
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
    }
  end
end
