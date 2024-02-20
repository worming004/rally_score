defmodule RallyScoreWeb.ChallengeLive.Index do
  use RallyScoreWeb, :live_view

  alias RallyScore.Scores
  alias RallyScore.Scores.Challenge

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :challenges, Scores.list_challenges())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Challenge")
    |> assign(:challenge, Scores.get_challenge!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Challenge")
    |> assign(:challenge, %Challenge{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Challenges")
    |> assign(:challenge, nil)
  end

  @impl true
  def handle_info({RallyScoreWeb.ChallengeLive.FormComponent, {:saved, challenge}}, socket) do
    {:noreply, stream_insert(socket, :challenges, challenge)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    challenge = Scores.get_challenge!(id)
    {:ok, _} = Scores.delete_challenge(challenge)

    {:noreply, stream_delete(socket, :challenges, challenge)}
  end
end
