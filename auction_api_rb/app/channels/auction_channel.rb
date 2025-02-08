class AuctionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "auction_#{params[:auction_id]}"
  end

  def unsubscribed
  end
end