class LineMessageService::TotalWinAmount < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    result = PlayerService::TotalWinAmount.call(line_group_id: @line_group_id)
    flex_message(result)
  end

  def flex_message(result)
    contents = result.map do |record|
      {
        type: "box",
        layout: "baseline",
        margin: "md",
        contents: [
          {
            type: "text",
            text: record[:name],
            weight: "bold",
            size: "md",
            margin: "xs",
            color: "#333333",
            contents: []
          },
          {
            type: "text",
            text: record[:total_win_amount].to_s,
            weight: "bold",
            size: "md",
            align: "end",
            margin: "xs",
            color: "#333333",
            contents: []
          }
        ]
      }
    end
    {
      type: 'flex',
      altText: '呼叫主選單',
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
                  text: "總成績",
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
              text: "包含正在進行中的遊戲",
              size: "xxs",
              color: "#AAAAAA",
              wrap: true,
              contents: []
            },
            {
              type: "box",
              layout: "vertical",
              spacing: "sm",
              margin: "lg",
              contents: contents
            }
          ]
        }
      }
    }
  end
end
