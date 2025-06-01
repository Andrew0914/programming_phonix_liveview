defmodule PentoWeb.Live.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  @impl true
  def update(_assigns, socket) do
    {:ok, socket |> assign_user_activity() |> assign_survey_users()}
  end

  defp assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end

  defp assign_survey_users(socket) do
    assign(socket, :survey_users_email, Presence.list_survey_users())
  end
end
