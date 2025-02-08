defmodule AuctionApi.Auctions.Bid do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bids" do
    field :amount, :integer

    belongs_to :user, AuctionApi.Accounts.User
    belongs_to :auction, AuctionApi.Auctions.Auction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [:amount])
    |> validate_required([:amount, :user_id, :auction_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_minimum_bid()
  end

  defp validate_minimum_bid(changeset) do
    case get_field(changeset, :auction_id) do
      nil -> changeset
      auction_id ->
        auction = AuctionApi.Repo.get(AuctionApi.Auctions.Auction, auction_id)

        if auction && auction.status == :closed do
          add_error(changeset, :amount, "Auction is closed")
        else
          min_bid = auction.current_bid + min_increment(get_field(changeset, :amount))
          if get_field(changeset, :amount) < min_bid do
            add_error(changeset, :amount, "must be at least #{min_bid}")
          else
            changeset
          end
        end
    end
  end

  defp min_increment(amount) do
    power = :math.pow(10, :math.floor(:math.log10(amount)) - 1)
    max(trunc(power), 1)
  end
end
