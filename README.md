# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## TODO

* 優化面板(太長) -> 看要不要別成兩張以上
* 控制板
* 自動下注
* 新增遊戲增加 GO

==== 功能 ====
- README
- TOTAL
- TODAY
==== 報告 ====
- 參與次數
- 當莊次數


## DUR

```
line_group = LineGroup.find(2)
line_group.players.each do |player|
  puts "#{player.id} - #{player.name}"
end

PaymentService::ConfirmPayment.call(game_bundle_id: payment_confirmation_id, player_id: player.id)
