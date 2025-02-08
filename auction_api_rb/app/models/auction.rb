class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids, dependent: :destroy

  enum status: { open: 'open', closed: 'closed' }

  validates :item_name, presence: true

  after_create_commit :schedule_closing
  after_create_commit :broadcast_start_auction

  private

  def winner_bid
    bids.order(amount: :desc).first
  end

  def schedule_closing
    AuctionCloseJob.set(wait: 30.seconds).perform_later(self)
  end

  def broadcast_start_auction
    ActionCable.server.broadcast("auction_#{id}", {
      status: status,
      item_name: item_name,
      current_bid: current_bid,
      auction_id: id
    })
  end
end
