defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive.Show

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic()}
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(demographic, socket)}
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    demographic = Survey.get_demographic_for_user(user)
    assign(socket, :demographic, demographic)
  end

  defp handle_demographic_created(demographic, socket) do
    socket
    |> assign(:demographic, demographic)
    |> put_flash(:info, "Demographic saved!!!")
  end
end
