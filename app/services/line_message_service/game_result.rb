class LineMessageService::GameResult < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)
    game = line_group.games.last
    bet_records = game.bet_records.includes(:player)
    dealer_bet_records = bet_records.find { |bet_record| bet_record.player_id == game.dealer.id }
    player_bet_records = bet_records.filter { |bet_record| bet_record.player_id != game.dealer.id }

    flex_message(dealer_bet_records, player_bet_records)
  end

  private

  def flex_message(dealer_bet_records, player_bet_records)
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
                text: "遊戲結果",
                weight: "bold",
                size: "md",
                contents: []
              }
            ]
          },
          {
            type: "separator",
            margin: "lg"
          },
          {
            type: "box",
            layout: "vertical",
            spacing: "sm",
            contents: [
              {
                type: "box",
                layout: "baseline",
                contents: [
                  {
                    type: "text",
                    text: dealer_bet_records.player.name,
                    weight: "bold",
                    contents: []
                  }
                ]
              },
              {
                type: "box",
                layout: "horizontal",
                margin: "md",
                contents: dealer_bet_records.cards.map do |card|
                  {
                    type: "image",
                    url:  PokerHelper.card_image(card),
                    align: "start"
                  }
                end + [
                  {
                    type: "text",
                    text: PokerHelper.score_to_text(dealer_bet_records.score),
                    weight: "bold",
                    color: "#000000",
                    gravity: "center",
                    margin: "xxl",
                    wrap: false,
                    contents: []
                  }
                ]
              },
              {
                type: "box",
                layout: "horizontal",
                margin: "lg",
                contents: [
                  {
                    type: "filler"
                  },
                  {
                    type: "text",
                    text: PokerHelper.win_amount_to_text(dealer_bet_records.win_amount),
                    weight: "bold",
                    color: "#000000",
                    margin: "md",
                    wrap: false,
                    contents: []
                  }
                ]
              }
            ]
          },
          {
            type: "separator"
          }
        ] + player_bet_records.map do |player_bet_record|
          {
            type: "box",
            layout: "vertical",
            spacing: "sm",
            contents: [
              {
                type: "box",
                layout: "baseline",
                contents: [
                  {
                    type: "text",
                    text: player_bet_record.player.name,
                    weight: "bold",
                    contents: []
                  }
                ]
              },
              {
                type: "box",
                layout: "horizontal",
                margin: "md",
                contents: player_bet_record.cards.map do |card|
                  {
                    type: "image",
                    url: PokerHelper.card_image(card),
                    align: "start"
                  }
                end + [
                  {
                    type: "text",
                    text: PokerHelper.score_to_text(player_bet_record.score),
                    weight: "bold",
                    color: "#000000",
                    gravity: "center",
                    margin: "xxl",
                    wrap: false,
                    contents: []
                  }
                ]
              },
              {
                type: "box",
                layout: "horizontal",
                margin: "lg",
                contents: [
                  {
                    type: "text",
                    text: "Bet: #{player_bet_record.bet_amount}",
                    weight: "bold",
                    color: "#000000",
                    margin: "md",
                    wrap: false,
                    contents: []
                  },
                  {
                    type: "text",
                    text: PokerHelper.win_amount_to_text(player_bet_record.win_amount),
                    weight: "bold",
                    color: "#000000",
                    margin: "md",
                    wrap: false,
                    contents: []
                  }
                ]
              },
              {
                type: "separator"
              }
            ]
          }
        end + [
          {
            type: "text",
            text: "新遊戲(莊家按)",
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
  end
end
