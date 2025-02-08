defmodule AuctionApiWeb.AuctionControllerTest do
  use AuctionApiWeb.ConnCase

  import AuctionApi.AuctionsFixtures

  alias AuctionApi.Auctions.Auction

  @create_attrs %{
    status: "some status",
    item_name: "some item_name",
    current_bid: 42,
    end_time: ~U[2025-02-07 06:05:00Z]
  }
  @update_attrs %{
    status: "some updated status",
    item_name: "some updated item_name",
    current_bid: 43,
    end_time: ~U[2025-02-08 06:05:00Z]
  }
  @invalid_attrs %{status: nil, item_name: nil, current_bid: nil, end_time: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all auctions", %{conn: conn} do
      conn = get(conn, ~p"/api/auctions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create auction" do
    test "renders auction when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/auctions", auction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/auctions/#{id}")

      assert %{
               "id" => ^id,
               "current_bid" => 42,
               "end_time" => "2025-02-07T06:05:00Z",
               "item_name" => "some item_name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/auctions", auction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update auction" do
    setup [:create_auction]

    test "renders auction when data is valid", %{conn: conn, auction: %Auction{id: id} = auction} do
      conn = put(conn, ~p"/api/auctions/#{auction}", auction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/auctions/#{id}")

      assert %{
               "id" => ^id,
               "current_bid" => 43,
               "end_time" => "2025-02-08T06:05:00Z",
               "item_name" => "some updated item_name",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, auction: auction} do
      conn = put(conn, ~p"/api/auctions/#{auction}", auction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete auction" do
    setup [:create_auction]

    test "deletes chosen auction", %{conn: conn, auction: auction} do
      conn = delete(conn, ~p"/api/auctions/#{auction}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/auctions/#{auction}")
      end
    end
  end

  defp create_auction(_) do
    auction = auction_fixture()
    %{auction: auction}
  end
end
