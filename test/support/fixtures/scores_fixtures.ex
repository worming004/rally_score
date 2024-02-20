defmodule RallyScore.ScoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RallyScore.Scores` context.
  """

  @doc """
  Generate a challenge.
  """
  def challenge_fixture(attrs \\ %{}) do
    {:ok, challenge} =
      attrs
      |> Enum.into(%{
        name: "some name",
        order: 42
      })
      |> RallyScore.Scores.create_challenge()

    challenge
  end
end
