defmodule RallyScoreWeb.Role do
  use RallyScoreWeb, :verified_routes
  import Plug.Conn
  import Phoenix.Controller
  alias RallyScore.Accounts

  def require_admin_or_redirect(conn, _opts) do
    if ensure_admin(conn) do
      conn
    else
      conn
      |> put_flash(:error, "Vous devez être un administrateur pour accéder a cette page")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end

  def ensure_admin(conn) do
    Accounts.is_user_admin(conn.assigns.current_user)
  end
end
