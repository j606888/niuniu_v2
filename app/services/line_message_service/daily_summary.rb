class LineMessageService::DailySummary < Service
  def initialize(line_group_id:)
    @line_group_id = line_group_id
  end

  def perform
    line_group = LineGroup.find_by(id: @line_group_id)
    timezone = 'Taipei'
    date = Date.today
    yesterday = date - 1
    day_before_yesterday = date - 2

    dates = [date, yesterday, day_before_yesterday]
    results = dates.map do |date|
      date_str = date.to_s
      result = PlayerService::TotalWinAmount.call(line_group_id: @line_group_id, date: date_str)
      result.present? ? { result: result, date: date } : nil
    end.compact

    if results.empty?
      {
        type: 'text',
        text: '找不到近期紀錄'
      }
    else
      {
        type: 'flex',
        altText: '近三天紀錄',
        contents: {
          type: 'carousel',
          contents: results.map { |result| bubble_message(result) }
        }
      }
    end
  end

  private

  def bubble_message(result)
    contents = result[:result].map do |record|
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
            color: "#333333",
            margin: "sm",
            contents: []
          },
          {
            type: "text",
            text: record[:total_win_amount].to_s,
            weight: "bold",
            size: "md",
            color: "#333333",
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
        contents: [
          {
            type: "box",
            layout: "horizontal",
            contents: [
              {
                type: "text",
                text: "單日戰績",
                weight: "bold",
                size: "md",
                align: "start",
                contents: []
              },
              {
                type: "text",
                text: result[:date],
                weight: "bold",
                size: "md",
                align: "end",
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
            margin: "lg",
            contents: contents
          }
        ]
      }
    }
  end
end
