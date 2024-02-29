class HomeController < ApplicationController
  def hello
    render json: { message: "Hello, niuniu_v2" }
  end
end
