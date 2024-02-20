defmodule RallyScoreWeb.Role do
  def require_admin(conn, _opts) do
    IO.puts(inspect(conn))
    conn
  end
end
