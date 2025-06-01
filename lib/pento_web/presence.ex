defmodule PentoWeb.Presence do
  @moduledoc """
  Provides presence tracking  to channels and processes.
  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details
  """
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias Pento.Accounts.User

  @user_activity_topic "user_activity"
  @survey_users_topic "survey_users"
  @taking_survey "taking_survey"

  def track_user(pid, product, user_email) do
    track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def track_survey_user(pid, %User{} = user) do
    track(pid, @survey_users_topic, @taking_survey, %{users: [%{email: user.email}]})
  end

  def list_products_and_users() do
    list(@user_activity_topic) |> Enum.map(&extract_product_with_user/1)
  end

  def list_survey_users() do
    list(@survey_users_topic) |> Enum.map(&extract_survey_users/1) |> List.flatten()
  end

  defp extract_survey_users({_survey_default_id, %{metas: metas}}) do
    metas |> Enum.map(&users_from_meta_map/1) |> List.flatten() |> Enum.uniq()
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
