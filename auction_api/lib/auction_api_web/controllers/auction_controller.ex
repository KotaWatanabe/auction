defmodule AuctionApiWeb.AuctionController do
  use AuctionApiWeb, :controller

  alias AuctionApi.Auctions
  alias AuctionApi.Auctions.Auction

  action_fallback AuctionApiWeb.FallbackController

  def create(conn, %{"user_id" => user_id, "item_name" => item_name}) do
    attrs = %{
      "user_id" => user_id,
      "item_name" => item_name,
      "status" => :open,
      "current_bid" => 1,
      "end_time" => NaiveDateTime.add(NaiveDateTime.utc_now(), 30, :second)
    }

    case Auctions.create_auction(attrs) do
      {:ok, auction} ->
        json(conn, auction)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
    end
  end

  def current(conn, _params) do
    case Auctions.get_current_auction() do
      nil -> json(conn, %{error: "No active auction"})
      auction -> json(conn, auction)
    end
  end
end
