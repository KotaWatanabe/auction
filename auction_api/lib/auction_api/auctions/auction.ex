defmodule AuctionApi.Auctions.Auction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "auctions" do
    field :status, :string
    field :item_name, :string
    field :current_bid, :integer
    field :end_time, :utc_datetime

    belongs_to :user, AuctionApi.Accounts.User
    has_many :bids, AuctionApi.Auctions.Bid

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auction, attrs) do
    auction
    |> cast(attrs, [:item_name, :current_bid, :status, :end_time])
    |> validate_required([:item_name, :current_bid, :status, :end_time])
  end
end
