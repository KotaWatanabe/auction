class BidsController < ApplicationController
  def create
    auction = Auction.find(params[:auction_id])
    bid = auction.bids.create!(user_id: params[:user_id], amount: params[:amount])
    auction.update(current_bid: bid.amount)
    render json: bid, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end