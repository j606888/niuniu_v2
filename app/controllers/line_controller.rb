class LineController < ApplicationController
  def hook
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each do |event|
      source = event.to_hash['source']
      next unless ['room', 'group'].include?(source['type'])

      line_group = LineGroup.find_by(
        room_id: source['roomId'],
        group_id: source['groupId']
      )
      if line_group.nil?
        LineGroup.create!(
          name: '妞妞決鬥場',
          room_id: source['roomId'],
          group_id: source['groupId']
        )
      end
      user_id = source['userId']
      player = Player.find_by(line_group: line_group, line_user_id: user_id)
      if player.nil?
        player_info = if line_group.group_id.present?
          LineApi.group_member_profile(line_group.group_id, user_id)
        else
          LineApi.room_member_profile(line_group.group_id, user_id)
        end

        player = Player.create!(line_group: line_group, line_user_id: user_id, name: player_info['displayName'])
      end

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text'].strip

          # if text.upcase == 'TEST'
          #   lose_message = LineMessageService::ForceSettle.call(line_group_id: line_group.id)

          #   r = client.reply_message(event['replyToken'], lose_message)
          #   break
          # end

          if text.upcase == 'README' || text.upcase == "READ ME"
            readme
            client.reply_message(event['replyToken'], readme)
            break
          end

          if text == '妞妞'
            client.reply_message(event['replyToken'], new_round_flex_message(line_group))
            break
          end

          match = text.match(/^\d+$/)
          if match && match[0].to_i != 0
            amount = match[0].to_i

            last_game = line_group.games.last
            if last_game.nil? || ['game_ended', 'game_canceled'].include?(last_game.aasm_state)
              begin
                GameService::Create.call(player_id: player.id, line_group_id: line_group.id, max_bet_amount: amount)
                client.reply_message(event['replyToken'], new_game_message(line_group))
              rescue GameService::Create::BetAmountOverMaxError => e
                client.reply_message(event['replyToken'], { type: 'text', text: "[失敗] 為了我們的友情，開局金額禁止超過 #{GameService::Create::MAX_BET_AMOUNT}" })
              rescue GameService::Create::TooManyUnpaidGameBundlesError => e
                client.reply_message(event['replyToken'], { type: 'text', text: "[失敗] 太多未確認收付的戰績，不給玩" })
              end
              break
            elsif last_game.aasm_state == 'bets_opened'
              begin
                GameService::PlayerBet.call(line_group_id: line_group.id, player_id: player.id, bet_amount: amount)
                client.reply_message(event['replyToken'], bet_message(player, amount))
              rescue GameService::PlayerBet::BetAmountOverMaxError => e
                client.reply_message(event['replyToken'], { type: 'text', text: "[失敗] 金額超出上限 (#{last_game.max_bet_amount})" })
              end
              break
            end
          end

          if text.upcase == "NOW"
            client.reply_message(event['replyToken'], current_bet(line_group))
            break
          end

          if text.upcase == "GO"
            GameService::Battle.call(dealer_id: player.id, line_group_id: line_group.id)
            lose_message = nil

            if any_player_lose_over_1000?(line_group)
              PaymentService::Settle.call(line_group_id: line_group.id)
              lose_message = LineMessageService::ForceSettle.call(line_group_id: line_group.id)
            end

            messages = [new_round_flex_message(line_group, with_game_result: true), lose_message].compact
            client.reply_message(event['replyToken'], messages)
            break
          end

          if text.upcase == "CANCEL"
            GameService::Cancel.call(player_id: player.id, line_group_id: line_group.id)
            client.reply_message(event['replyToken'], [{ type: 'text', text: "已取消遊戲" }, new_round_flex_message(line_group)])
            break
          end

          if text.upcase == "SETTLE"
            PaymentService::Settle.call(line_group_id: line_group.id)
            client.reply_message(event['replyToken'], [{ type: 'text', text: "結算成功，該付錢囉各位" }, new_round_flex_message(line_group)])
          end

          match = text.match(/^CONFIRM SCORE #(\d+)$/)
          if match
            payment_confirmation_id = match[1].to_i
            PaymentService::ConfirmPayment.call(game_bundle_id: payment_confirmation_id, player_id: player.id)
            client.reply_message(event['replyToken'], { type: 'text', text: "#{player.name} 已確認收付" })
            break
          end
        end
      end
    end

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV["NIUNIU_V2_LINE_CHANNEL_ID"]
      config.channel_secret = ENV["NIUNIU_V2_LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["NIUNIU_V2_LINE_CHANNEL_ACCESS_TOKEN"]
    }
  end

  def new_round_flex_message(line_group, with_game_result: false)
    LineMessageService::Dashboard.call(line_group_id: line_group.id, with_game_result: with_game_result)
  end

  def new_game_message(line_group)
    LineMessageService::NewGame.call(line_group_id: line_group.id)
  end

  def bet_message(player, bet_amount)
    LineMessageService::Bet.call(player_id: player.id, bet_amount: bet_amount)
  end

  def current_bet(line_group)
    LineMessageService::CurrentBet.call(line_group_id: line_group.id)
  end

  def game_result(line_group)
    LineMessageService::GameResult.call(line_group_id: line_group.id)
  end

  def readme
    LineMessageService::Readme.call
  end

  def any_player_lose_over_1000?(line_group)
    PlayerService::UnsettleWinAmount.call(line_group_id: line_group.id).values.any? { |win_amount| win_amount <= -1000 }
  end
end
