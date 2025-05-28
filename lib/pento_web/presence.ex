defmodule PentoWeb.Presence do
  @moduledoc """
  Provides presence tracking  to channels and processes.
  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details
  """
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  @user_activity_topic "user_activity"

  def track_user(pid, product, user_email) do
    track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def list_products_and_users() do
    list(@user_activity_topic) |> Enum.map(&extract_product_with_user/1)
  end

  defp extract_product_with_user({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    metas_list |> Enum.map(&users_from_meta_map/1) |> List.flatten() |> Enum.uniq()
  end

  defp users_from_meta_map(meta_map) do
    meta_map |> get_in([:users])
  end
end
