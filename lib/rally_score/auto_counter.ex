defmodule RallyScore.AutoCounter do
  use GenServer
  require Logger

  # Client

  def start_link(default \\ 0) do
    GenServer.start_link(__MODULE__, %{:counter => default}, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def subscribe() do
    RallyScoreWeb.Endpoint.subscribe("auto_counter")
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    schedule()
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state = %{:counter => counter}) do
    {:reply, counter, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  @impl true
  def handle_info(:tick, state) do
    schedule()
    state = Map.update!(state, :counter, &(&1 + 1))
    Phoenix.PubSub.broadcast(RallyScore.PubSub, "auto_counter", state)
    {:noreply, state}
  end

  defp schedule do
    Process.send_after(self(), :tick, 1_000)
  end
end
