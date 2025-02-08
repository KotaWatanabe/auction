class AuctionCloseJob < ApplicationJob
  queue_as :default

  def perform(auction)
    auction.update!(status: "closed")

    ActionCable.server.broadcast("auction_#{auction.id}", {
      status: "closed",
      user: auction.user.id,
      current_bid: auction.current_bid,
      winner_bid: auction.winner_bid&.amount || "No bids",
      auction_id: auction.id
    })
  end
end