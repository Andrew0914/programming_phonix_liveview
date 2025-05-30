defmodule PentoWeb.Live.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  @impl true
  def update(_assigns, socket) do
    {:ok, socket |> assign_user_activity()}
  end

  defp assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
