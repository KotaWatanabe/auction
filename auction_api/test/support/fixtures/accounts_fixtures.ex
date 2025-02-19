defmodule AuctionApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuctionApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        role: "some role"
      })
      |> AuctionApi.Accounts.create_user()

    user
  end
end
