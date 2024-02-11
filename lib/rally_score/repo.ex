defmodule RallyScore.Repo do
  use Ecto.Repo,
    otp_app: :rally_score,
    adapter: Ecto.Adapters.Postgres
end
