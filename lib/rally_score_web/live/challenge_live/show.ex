defmodule RallyScoreWeb.ChallengeLive.Show do
  use RallyScoreWeb, :live_view

  alias RallyScore.Scores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:challenge, Scores.get_challenge!(id))}
  end

  defp page_title(:show), do: "Show Challenge"
  defp page_title(:edit), do: "Edit Challenge"
end
