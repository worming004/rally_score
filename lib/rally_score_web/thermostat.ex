defmodule RallyScoreWeb.ThermostatLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    ~H"""
    Current temperature: <%= @temperature %>°F <button phx-click="inc_temperature">+</button>
    Current tick: <%= @tick %> ticked
    """
  end

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    # Let's assume a fixed temperature for now
    temperature = user_id
    {:ok, assign(socket, :temperature, temperature)}
  end

  def mount(_params, _session, socket) do
    # Let's assume a fixed temperature for now
    temperature = 70
    RallyScoreWeb.Endpoint.subscribe("auto_counter")
    {:ok, assign(socket, :temperature, temperature) |> assign(:tick, 0)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end

  def handle_info(_thing = %{:counter => tick}, socket) do
    {:noreply, socket |> assign(:tick, tick)}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
