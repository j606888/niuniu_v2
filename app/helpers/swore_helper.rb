module SworeHelper
  SWORE_WORDS = [
    "去你媽的",
    "吃屎吧你",
    "你以為你也有杏鮑菇嗎這小老二",
    "你是不是有病啊",
    "輸錢就乖乖付錢啦廢物",
    "可撥仔",
    "我阿嬤都比你會玩"
    "哈哈哈哈哈哈哈",
    "不要在尻槍了"
    "好啊，一起輸"
  ]

  class << self
    def pick_swore_word
      SWORE_WORDS.sample
    end
  end
end
