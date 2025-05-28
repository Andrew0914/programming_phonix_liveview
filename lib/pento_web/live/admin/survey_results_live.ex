defmodule PentoWeb.Live.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live

  alias Pento.Catalog
  alias Contex

  @impl true
  def update(assigns, socket) do
    {:ok,
     assign(socket, assigns)
     |> assign_filter()
     |> assign_products_with_average_ratings()
     |> assign_data()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp assign_products_with_average_ratings(%{assigns: %{filter: filter}} = socket) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_filter(filter)
    )
  end

  defp assign_data(
         %{assigns: %{products_with_average_ratings: products_with_average_ratings}} = socket
       ) do
    socket |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket |> assign(:chart, make_bar_chart(dataset))
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(
      :chart_svg,
      render_bar_chart(
        chart,
        "Product Ratings 🔥🔥🔥",
        "Average Rating per Product",
        "products",
        "stars"
      )
    )
  end

  defp assign_filter(socket, %{"age_group_filter" => age_group_filter}) do
    socket |> assign(:filter, {:age_group_filter, age_group_filter})
  end

  defp assign_filter(socket, %{"gender_filter" => gender_filter}) do
    socket |> assign(:filter, {:gender_filter, gender_filter})
  end

  defp assign_filter(%{assigns: %{filter: filter}} = socket) do
    socket |> assign(:filter, filter)
  end

  defp assign_filter(socket) do
    socket |> assign(:filter, {:age_group_filter, "all"})
  end

  @impl true
  def handle_event("filter_by_age_group", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
     socket
     |> assign_filter(%{"age_group_filter" => age_group_filter})
     |> assign_products_with_average_ratings()
     |> assign_data()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  @impl true
  def handle_event("filter_by_gender", %{"gender_filter" => gender_filter}, socket) do
    {:noreply,
     socket
     |> assign_filter(%{"gender_filter" => gender_filter})
     |> assign_products_with_average_ratings()
     |> assign_data()
     |> assign_chart()
     |> assign_chart_svg()}
  end

  defp get_products_with_average_filter({:age_group_filter, filter}) do
    IO.puts("💧")

    case Catalog.products_with_average_ratings(%{age_group_filter: filter}) do
      [] -> Catalog.products_with_zero_ratings()
      products -> products
    end
  end

  defp get_products_with_average_filter({:gender_filter, filter}) do
    IO.puts("🔥")

    case Catalog.products_with_average_ratings(%{gender_filter: filter}) do
      [] -> Catalog.products_with_zero_ratings()
      products -> products
    end
  end
end
