defmodule AuctionApi.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :auction_id, references(:auctions, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:bids, [:user_id])
    create index(:bids, [:auction_id])
  end
end
