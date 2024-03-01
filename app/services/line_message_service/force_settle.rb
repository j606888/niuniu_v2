class LineMessageService::ForceSettle < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find(@line_group_id)
    game_bundle = line_group.game_bundles.last
    loser = game_bundle.payment_confirmations.sort_by(&:amount).first.player
    flex_message(loser)
  end

  private

  def flex_message(loser)
    {
      type: 'flex',
      altText: "強制結算",
      contents: {
        type: "bubble",
        body: {
          type: "box",
          layout: "vertical",
          spacing: "md",
          contents: [
            {
              type: "text",
              text: "強制結算",
              weight: "bold",
              size: "xxl",
              color: "#FD0C0CFF",
              align: "center",
              contents: []
            },
            {
              type: "separator",
              margin: "lg"
            },
            {
              type: "text",
              text: "#{loser.name} 不幸的輸破 1000",
              weight: "regular",
              margin: "xl",
              wrap: true,
              contents: []
            },
            {
              type: "text",
              text: "系統強制結算，請確認付款後再繼續復仇ㄅ",
              weight: "regular",
              wrap: true,
              contents: []
            }
          ]
        }
      }
    }
  end
end
