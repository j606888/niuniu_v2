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

        Player.create!(line_group: line_group, line_user_id: user_id, name: player_info['displayName'])
      end

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = event.message['text']
          if text == '妞妞'
            client.reply_message(event['replyToken'], new_round_flex_message(line_group))
            break
          end

          match = text.match(/LIMIT\s+(\d+)/)
          if match
            max_bet_amount = match[1].to_i
            # 要建立新遊戲
            client.reply_message(event['replyToken'], new_game_message(line_group))
            break
          end

          match = text.match(/^\d+$/)
          if match
            # 要真的下注
            bet_amount = match[0].to_i
            GameService::PlayerBet.call(line_group_id: line_group.id, player_id: player.id, bet_amount: bet_amount)
            client.reply_message(event['replyToken'], bet_message(player, bet_amount))
            break
          end

          if text == "STOP"
            # GameService::Lock.call(player_id: player.id, line_group_id: line_group.id)
            client.reply_message(event['replyToken'], bets_locked(line_group))
            break
          end

          if text == "GOGO"
            # GameService::Battle.call(dealer_id: player.id, line_group_id: line_group.id)
            client.reply_message(event['replyToken'], game_result(line_group))
            break
          end
          # message = {
          #   type: 'text',
          #   text: event.message['text']
          # }
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

  def new_round_flex_message(line_group)
    LineMessageService::Dashboard.call(line_group_id: line_group.id)
  end

  def new_game_message(line_group)
    LineMessageService::NewGame.call(line_group_id: line_group.id)
  end

  def bet_message(player, bet_amount)
    LineMessageService::Bet.call(player_id: player.id, bet_amount: bet_amount)
  end

  def bets_locked(line_group)
    LineMessageService::Lock.call(line_group_id: line_group.id)
  end

  def game_result(line_group)
    LineMessageService::GameResult.call(line_group_id: line_group.id)
  end
end
