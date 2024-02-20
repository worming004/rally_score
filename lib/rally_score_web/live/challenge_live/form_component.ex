defmodule RallyScoreWeb.ChallengeLive.FormComponent do
  use RallyScoreWeb, :live_component

  alias RallyScore.Scores

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage challenge records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="challenge-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:order]} type="number" label="Order" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Challenge</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{challenge: challenge} = assigns, socket) do
    changeset = Scores.change_challenge(challenge)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"challenge" => challenge_params}, socket) do
    changeset =
      socket.assigns.challenge
      |> Scores.change_challenge(challenge_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"challenge" => challenge_params}, socket) do
    save_challenge(socket, socket.assigns.action, challenge_params)
  end

  defp save_challenge(socket, :edit, challenge_params) do
    case Scores.update_challenge(socket.assigns.challenge, challenge_params) do
      {:ok, challenge} ->
        notify_parent({:saved, challenge})

        {:noreply,
         socket
         |> put_flash(:info, "Challenge updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_challenge(socket, :new, challenge_params) do
    case Scores.create_challenge(challenge_params) do
      {:ok, challenge} ->
        notify_parent({:saved, challenge})

        {:noreply,
         socket
         |> put_flash(:info, "Challenge created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
