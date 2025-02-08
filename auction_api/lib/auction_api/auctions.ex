defmodule AuctionApi.Auctions do
  @moduledoc """
  The Auctions context.
  """

  import Ecto.Query, warn: false
  alias AuctionApi.Repo

  alias AuctionApi.Auctions.Auction

  @doc """
  Returns the list of auctions.

  ## Examples

      iex> list_auctions()
      [%Auction{}, ...]

  """
  def list_auctions do
    Repo.all(Auction)
  end

  @doc """
  Gets a single auction.

  Raises `Ecto.NoResultsError` if the Auction does not exist.

  ## Examples

      iex> get_auction!(123)
      %Auction{}

      iex> get_auction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_auction!(id), do: Repo.get!(Auction, id)

  @doc """
  Creates a auction.

  ## Examples

      iex> create_auction(%{field: value})
      {:ok, %Auction{}}

      iex> create_auction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_auction(attrs \\ %{}) do
    %Auction{}
    |> Auction.changeset(attrs)
    |> Repo.insert()
  end

  def get_current_auction() do
    Auction
    |> where([a], a.status == :open)
    |> order_by([a], desc: a.inserted_at)
    |> Repo.one()
  end

  def place_bid(%{"auction_id" => auction_id, "user_id" => user_id, "amount" => amount}) do
    auction = Repo.get!(Auction, auction_id)

    if auction.status == :closed do
      {:error, "Auction is closed"}
    else
      bid_changeset = Bid.changeset(%Bid{}, %{"auction_id" => auction_id, "user_id" => user_id, "amount" => amount})

      case Repo.insert(bid_changeset) do
        {:ok, bid} ->
          auction
          |> Ecto.Changeset.change(current_bid: bid.amount)
          |> Repo.update()

          {:ok, bid}
        {:error, changeset} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Updates a auction.

  ## Examples

      iex> update_auction(auction, %{field: new_value})
      {:ok, %Auction{}}

      iex> update_auction(auction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_auction(%Auction{} = auction, attrs) do
    auction
    |> Auction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a auction.

  ## Examples

      iex> delete_auction(auction)
      {:ok, %Auction{}}

      iex> delete_auction(auction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_auction(%Auction{} = auction) do
    Repo.delete(auction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking auction changes.

  ## Examples

      iex> change_auction(auction)
      %Ecto.Changeset{data: %Auction{}}

  """
  def change_auction(%Auction{} = auction, attrs \\ %{}) do
    Auction.changeset(auction, attrs)
  end

  alias AuctionApi.Auctions.Bid

  @doc """
  Returns the list of bids.

  ## Examples

      iex> list_bids()
      [%Bid{}, ...]

  """
  def list_bids do
    Repo.all(Bid)
  end

  @doc """
  Gets a single bid.

  Raises `Ecto.NoResultsError` if the Bid does not exist.

  ## Examples

      iex> get_bid!(123)
      %Bid{}

      iex> get_bid!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bid!(id), do: Repo.get!(Bid, id)

  @doc """
  Creates a bid.

  ## Examples

      iex> create_bid(%{field: value})
      {:ok, %Bid{}}

      iex> create_bid(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bid(attrs \\ %{}) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bid.

  ## Examples

      iex> update_bid(bid, %{field: new_value})
      {:ok, %Bid{}}

      iex> update_bid(bid, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bid(%Bid{} = bid, attrs) do
    bid
    |> Bid.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bid.

  ## Examples

      iex> delete_bid(bid)
      {:ok, %Bid{}}

      iex> delete_bid(bid)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bid(%Bid{} = bid) do
    Repo.delete(bid)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bid changes.

  ## Examples

      iex> change_bid(bid)
      %Ecto.Changeset{data: %Bid{}}

  """
  def change_bid(%Bid{} = bid, attrs \\ %{}) do
    Bid.changeset(bid, attrs)
  end
end
