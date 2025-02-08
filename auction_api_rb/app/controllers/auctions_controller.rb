class AuctionsController < ApplicationController
  def create
    auction = Auction.create!(auction_params.merge(user_id: params[:user_id], status: 'open', current_bid: 1, end_time: 30.seconds.from_now))
    render json: auction, status: :created
  end

  def current
    current_auction = Auction.where(status: 'open').order(created_at: :desc).first
    render json: current_auction, status: :ok
  end

  private
  def auction_params
    params.require(:auction).permit(:item_name)
  end
end
