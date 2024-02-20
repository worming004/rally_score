defmodule RallyScore.Scores.Challenge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "challenges" do
    field :name, :string
    field :order, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(challenge, attrs) do
    challenge
    |> cast(attrs, [:name, :order])
    |> validate_required([:name, :order])
  end
end
