defmodule AuctionApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :role, :string

    has_many :auctions, AuctionApi.Auctions.Auction
    has_many :bids, AuctionApi.Auctions.Bid

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role])
    |> validate_required([:name, :role])
  end
end
