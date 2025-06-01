defmodule PentoWeb.SurveyLive do
  alias PentoWeb.Endpoint
  use PentoWeb, :live_view

  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive.Show
  alias PentoWeb.RatingLive
  alias Pento.Catalog
  alias Phoenix.LiveView.JS
  alias PentoWeb.Presence

  @survey_results_topic "survey_results"

  @impl true
  def mount(_params, _session, socket) do
    maybe_track_survey_users(socket)

    {:ok,
     socket |> assign_demographic() |> assign_products() |> assign(:ratin_is_collapse, false)}
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(demographic, socket)}
  end

  @impl true
  def handle_info({:rating_product_created, product, product_index}, socket) do
    {:noreply, handle_rating_created(product, product_index, socket)}
  end

  @impl true
  def handle_info({:collapse, is_collapse}, socket) do
    {:noreply, socket |> assign(:ratin_is_collapse, is_collapse)}
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

  defp handle_rating_created(product, product_index, socket) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> assign(:products, List.replace_at(socket.assigns.products, product_index, product))
    |> put_flash(:info, "Rating saved!!!")
  end

  def assign_products(%{assigns: %{current_user: user}} = socket) do
    assign(socket, :products, list_products(user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_ratings(user)
  end

  def toggle_ratings(js \\ %JS{}) do
    js |> JS.toggle(to: "#rating_list")
  end

  def maybe_track_survey_users(socket) do
    if(connected?(socket)) do
      user = socket.assigns.current_user
      Presence.track_survey_user(self(), user)
    end
  end
end
