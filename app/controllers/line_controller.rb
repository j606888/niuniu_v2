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
          message = {
            type: 'text',
            text: event.message['text']
          }
          # client.reply_message(event['replyToken'], message)
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
end
