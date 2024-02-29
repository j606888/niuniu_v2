class LineMessageService::UnpaidBundle < Service
  def initialize(game_bundle_id:)
    @game_bundle_id = game_bundle_id
  end

  def perform
    game_bundle = GameBundle.find(@game_bundle_id)
    line_group = game_bundle.line_group
    payment_confirmations = game_bundle.payment_confirmations.includes(:player)

    flex_message(game_bundle, payment_confirmations)
  end

  private

  def flex_message(game_bundle, payment_confirmations)
    contents = payment_confirmations.map do |payment_confirmation|
      icon = payment_confirmation.is_confirmed ? "✅" : "🐵"
      {
        type: "box",
        layout: "baseline",
        contents: [
          {
            type: "text",
            text: "#{icon} #{payment_confirmation.player.name}",
            weight: "bold",
            margin: "sm",
            contents: []
          },
          {
            type: "text",
            text: payment_confirmation.amount.to_s,
            size: "sm",
            color: "#666666",
            align: "end",
            contents: []
          }
        ]
      }
    end
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
                text: "未結清債務 ##{game_bundle.id}",
                weight: "bold",
                size: "md",
                align: "center",
                contents: []
              }
            ]
          },
          {
            type: "separator",
            margin: "lg"
          },
          {
            type: "text",
            text: "累積兩筆未結清債務將禁止新遊戲",
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
            text: "結清請按此",
            size: "xxs",
            color: "#AAAAAA",
            wrap: true,
            contents: []
          },
          {
            type: "button",
            action: {
              type: "message",
              label: "確認結清",
              text: "CONFIRM SETTLE ##{game_bundle.id}"
            },
            color: "#2196F3",
            height: "sm",
            style: "primary"
          }
        ]
      }
    }
  end
end
