# https://developers.line.biz/en/reference/messaging-api/#get-group-member-profile

class LineApi
  APP_HOST = "https://api.line.me/v2/bot"
  CHANNEL_ACCESS_TOKEN = ENV["NIUNIU_V2_LINE_CHANNEL_ACCESS_TOKEN"]

  class << self
    def group_member_profile(group_id, user_id)
      path = "/group/#{group_id}/member/#{user_id}"
      headers = { 'Authorization' => "Bearer #{CHANNEL_ACCESS_TOKEN}" }
      response = HTTParty.get("#{APP_HOST}#{path}" , headers: headers)
    end

    def room_member_profile(room_id, user_id)
      path = "/room/#{room_id}/member/#{user_id}"
      headers = { 'Authorization' => "Bearer #{CHANNEL_ACCESS_TOKEN}" }
      response = HTTParty.get("#{APP_HOST}#{path}" , headers: headers)
    end
  end
end
