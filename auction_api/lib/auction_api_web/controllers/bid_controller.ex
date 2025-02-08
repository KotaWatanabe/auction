defmodule AuctionApiWeb.BidController do
  use AuctionApiWeb, :controller

  alias AuctionApi.Auctions
  alias AuctionApi.Auctions.Bid

  action_fallback AuctionApiWeb.FallbackController

  def create(conn, params) do
    case Auctions.place_bid(params) do
      {:ok, bid} -> json(conn, bid)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
      {:error, msg} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: msg})
    end
  end
end
