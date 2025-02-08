defmodule AuctionApi.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :item_name, :string
      add :current_bid, :integer
      add :status, :string
      add :end_time, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:auctions, [:user_id])
  end
end
