defmodule PentoWeb.Admin.DashboardLive do
  alias PentoWeb.Live.Admin.UserActivityLive
  alias PentoWeb.Live.Admin.SurveyResultsLive
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survey_users_topic "survey_users"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Subscribing to topics
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survey_users_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")
     |> assign(:user_activity_component_id, "user-activity")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)
    {:noreply, socket}
  end
end
