defmodule AuctionApi.AuctionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuctionApi.Auctions` context.
  """

  @doc """
  Generate a auction.
  """
  def auction_fixture(attrs \\ %{}) do
    {:ok, auction} =
      attrs
      |> Enum.into(%{
        current_bid: 42,
        end_time: ~U[2025-02-07 06:05:00Z],
        item_name: "some item_name",
        status: "some status"
      })
      |> AuctionApi.Auctions.create_auction()

    auction
  end

  @doc """
  Generate a bid.
  """
  def bid_fixture(attrs \\ %{}) do
    {:ok, bid} =
      attrs
      |> Enum.into(%{
        amount: 42
      })
      |> AuctionApi.Auctions.create_bid()

    bid
  end
end
