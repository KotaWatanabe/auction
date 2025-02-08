class User < ApplicationRecord
  has_many :auctions
  has_many :bids
end
