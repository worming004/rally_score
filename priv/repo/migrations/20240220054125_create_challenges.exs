defmodule RallyScore.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :name, :string
      add :order, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
