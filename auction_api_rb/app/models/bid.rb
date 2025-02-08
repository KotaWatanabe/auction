class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  validates :amount, numericality: { greater_than: 0 }
  validate :valid_minimum_bid, on: :create
  after_create_commit :broadcast_bid

  private

  def valid_minimum_bid
    return if auction.closed?

    min_bid = auction.current_bid + min_increment(amount)
    errors.add(:amount, "must be at least #{min_bid}") if amount < min_bid
  end

  def min_increment(amount)
    power = 10**(Math.log10(amount).floor - 1)
    [power, 1].max
  end

  def broadcast_bid
    ActionCable.server.broadcast("auction_#{auction.id}", { bid: amount, user: user.id })
  end
end
