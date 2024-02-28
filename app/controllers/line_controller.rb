class LineController < ApplicationController
  def hook
    head :ok

    binding.pry
  end
end
