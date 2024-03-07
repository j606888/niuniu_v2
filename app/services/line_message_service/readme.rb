class LineMessageService::Readme < Service
  def initialize; end

  def perform
    flex_message
  end

  private

  def flex_message
    {
      type: 'flex',
      altText: '呼叫主選單',
      contents: {
        type: "carousel",
        contents: [
          {
            type: "bubble",
            body: {
              type: "box",
              layout: "vertical",
              spacing: "md",
              contents: [
                {
                  type: "text",
                  text: "使用說明 (1)",
                  weight: "bold",
                  size: "xxl",
                  color: "#FD0C0CFF",
                  align: "center",
                  contents: []
                },
                {
                  type: "box",
                  layout: "vertical",
                  contents: [
                    {
                      type: "separator",
                      margin: "lg"
                    },
                    {
                      type: "text",
                      text: "開局：",
                      weight: "bold",
                      margin: "lg",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "可以按「30」「50」或是直接輸入你的上限值。例如：130",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "為了預防大家走火入魔，上限值最高只能設到 #{BingoHelper.max_bet_amount}",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    }
                  ]
                },
                {
                  type: "box",
                  layout: "vertical",
                  contents: [
                    {
                      type: "separator",
                      margin: "lg"
                    },
                    {
                      type: "text",
                      text: "下注：",
                      weight: "bold",
                      margin: "lg",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "可以按「30」「50」或是直接輸入你的下注。例如：87",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "如果在發牌之前重複下注，都會是以最後的下注為主",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    }
                  ]
                },
                {
                  type: "box",
                  layout: "vertical",
                  contents: [
                    {
                      type: "separator",
                      margin: "lg"
                    },
                    {
                      type: "text",
                      text: "提示：",
                      weight: "bold",
                      margin: "lg",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "指令都是可以自行輸入的不一定要按按鈕，例如：GO 或是 NOW",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    }
                  ]
                }
              ]
            }
          },
          {
            type: "bubble",
            body: {
              type: "box",
              layout: "vertical",
              spacing: "md",
              contents: [
                {
                  type: "text",
                  text: "使用說明 (2)",
                  weight: "bold",
                  size: "xxl",
                  color: "#FD0C0CFF",
                  align: "center",
                  contents: []
                },
                {
                  type: "box",
                  layout: "vertical",
                  contents: [
                    {
                      type: "separator",
                      margin: "lg"
                    },
                    {
                      type: "text",
                      text: "結算：",
                      weight: "bold",
                      margin: "lg",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "請勿亂按，期望是一天按一次即可",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "按下後就代表要付錢了",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "<注意> 如果有人分數低於 -1000 的話系統也會強制結算，避免積欠太多",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    }
                  ]
                },
                {
                  type: "box",
                  layout: "vertical",
                  contents: [
                    {
                      type: "separator",
                      margin: "lg"
                    },
                    {
                      type: "text",
                      text: "未確認戰績：",
                      weight: "bold",
                      margin: "lg",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "🐵 ：尚未確認 ，✅：確認完畢",
                      margin: "lg",
                      contents: []
                    },
                    {
                      type: "text",
                      text: "自行商量誰給誰多少。等到自己的部分付款或者收到的時候再按下「確認收付」。全部的人都按過之後這張戰績就會消失。",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    },
                    {
                      type: "text",
                      text: "<注意> 為避免有人積欠金額，當有\"兩張\"未確認戰績就會禁止新遊戲。請大家去撻伐還沒按下確認鍵的人",
                      weight: "regular",
                      margin: "md",
                      wrap: true,
                      contents: []
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    }
  end
end
