defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_demographic() |> clear_form()}
  end

  @impl true
  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, socket |> save_demographic(params)}
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    socket |> assign(:demographic, %Demographic{user_id: user.id})
  end

  defp assign_form(socket, changeset) do
    socket |> assign(:form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic}} = socket) do
    socket |> assign_form(Survey.change_demographic(demographic))
  end

  defp params_with_user_id(params, %{assigns: %{current_user: user}}) do
    Map.put(params, "user_id", user.id)
  end

  def save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, changeset} ->
        assign_form(socket, changeset)
    end
  end
end
