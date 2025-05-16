defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive.Show

  @messages [
    "First title",
    "Second title",
    "Third title",
    "Fourth title",
    "Fifth title",
    "Sixth title",
    "Seventh title",
    "Eighth title",
    "Ninth title",
    "Tenth title"
  ]

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic() |> assign(:messages, @messages)}
  end

  defp assign_demographic(%{assigns: %{current_user: user}} = socket) do
    demographic = Survey.get_demographic_for_user(user)
    assign(socket, :demographic, demographic)
  end
end
