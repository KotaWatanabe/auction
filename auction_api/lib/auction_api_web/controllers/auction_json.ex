defmodule AuctionApiWeb.AuctionJSON do
  alias AuctionApi.Auctions.Auction

  @doc """
  Renders a list of auctions.
  """
  def index(%{auctions: auctions}) do
    %{data: for(auction <- auctions, do: data(auction))}
  end

  @doc """
  Renders a single auction.
  """
  def show(%{auction: auction}) do
    %{data: data(auction)}
  end

  defp data(%Auction{} = auction) do
    %{
      id: auction.id,
      item_name: auction.item_name,
      current_bid: auction.current_bid,
      status: auction.status,
      end_time: auction.end_time
    }
  end
end
