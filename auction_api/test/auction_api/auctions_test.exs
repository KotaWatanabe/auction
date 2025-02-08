defmodule AuctionApi.AuctionsTest do
  use AuctionApi.DataCase

  alias AuctionApi.Auctions

  describe "auctions" do
    alias AuctionApi.Auctions.Auction

    import AuctionApi.AuctionsFixtures

    @invalid_attrs %{status: nil, item_name: nil, current_bid: nil, end_time: nil}

    test "list_auctions/0 returns all auctions" do
      auction = auction_fixture()
      assert Auctions.list_auctions() == [auction]
    end

    test "get_auction!/1 returns the auction with given id" do
      auction = auction_fixture()
      assert Auctions.get_auction!(auction.id) == auction
    end

    test "create_auction/1 with valid data creates a auction" do
      valid_attrs = %{status: "some status", item_name: "some item_name", current_bid: 42, end_time: ~U[2025-02-07 06:05:00Z]}

      assert {:ok, %Auction{} = auction} = Auctions.create_auction(valid_attrs)
      assert auction.status == "some status"
      assert auction.item_name == "some item_name"
      assert auction.current_bid == 42
      assert auction.end_time == ~U[2025-02-07 06:05:00Z]
    end

    test "create_auction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_auction(@invalid_attrs)
    end

    test "update_auction/2 with valid data updates the auction" do
      auction = auction_fixture()
      update_attrs = %{status: "some updated status", item_name: "some updated item_name", current_bid: 43, end_time: ~U[2025-02-08 06:05:00Z]}

      assert {:ok, %Auction{} = auction} = Auctions.update_auction(auction, update_attrs)
      assert auction.status == "some updated status"
      assert auction.item_name == "some updated item_name"
      assert auction.current_bid == 43
      assert auction.end_time == ~U[2025-02-08 06:05:00Z]
    end

    test "update_auction/2 with invalid data returns error changeset" do
      auction = auction_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_auction(auction, @invalid_attrs)
      assert auction == Auctions.get_auction!(auction.id)
    end

    test "delete_auction/1 deletes the auction" do
      auction = auction_fixture()
      assert {:ok, %Auction{}} = Auctions.delete_auction(auction)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_auction!(auction.id) end
    end

    test "change_auction/1 returns a auction changeset" do
      auction = auction_fixture()
      assert %Ecto.Changeset{} = Auctions.change_auction(auction)
    end
  end

  describe "bids" do
    alias AuctionApi.Auctions.Bid

    import AuctionApi.AuctionsFixtures

    @invalid_attrs %{amount: nil}

    test "list_bids/0 returns all bids" do
      bid = bid_fixture()
      assert Auctions.list_bids() == [bid]
    end

    test "get_bid!/1 returns the bid with given id" do
      bid = bid_fixture()
      assert Auctions.get_bid!(bid.id) == bid
    end

    test "create_bid/1 with valid data creates a bid" do
      valid_attrs = %{amount: 42}

      assert {:ok, %Bid{} = bid} = Auctions.create_bid(valid_attrs)
      assert bid.amount == 42
    end

    test "create_bid/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_bid(@invalid_attrs)
    end

    test "update_bid/2 with valid data updates the bid" do
      bid = bid_fixture()
      update_attrs = %{amount: 43}

      assert {:ok, %Bid{} = bid} = Auctions.update_bid(bid, update_attrs)
      assert bid.amount == 43
    end

    test "update_bid/2 with invalid data returns error changeset" do
      bid = bid_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_bid(bid, @invalid_attrs)
      assert bid == Auctions.get_bid!(bid.id)
    end

    test "delete_bid/1 deletes the bid" do
      bid = bid_fixture()
      assert {:ok, %Bid{}} = Auctions.delete_bid(bid)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_bid!(bid.id) end
    end

    test "change_bid/1 returns a bid changeset" do
      bid = bid_fixture()
      assert %Ecto.Changeset{} = Auctions.change_bid(bid)
    end
  end
end
