defmodule PentoWeb.SearchLive.Index do
  use PentoWeb, :live_view

  alias Pento.Searcher.Search
  alias Pento.Searcher

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:products, [])
     |> assign_search()
     |> clear_form()}
  end

  defp assign_search(socket) do
    assign(socket, :search, %Search{})
  end

  defp clear_form(socket) do
    changeset = Searcher.change_search(socket.assigns.search)
    assign_form(socket, changeset)
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"search" => params}, socket) do
    changeset =
      Searcher.change_search(socket.assigns.search, params) |> Map.put(:action, :validate)

    IO.inspect(changeset)
    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("search", %{"search" => params}, socket) do
    changeset = Searcher.change_search(socket.assigns.search, params)

    with true <- changeset.valid?,
         {:ok, products} <- Searcher.search_products_by_sku(Map.get(params, "sku")) do
      {:noreply,
       socket
       |> stream(:products, products)
       |> clear_form()
       |> put_flash(:info, "Search successful")}
    else
      _ -> {:noreply, socket |> clear_form() |> put_flash(:error, "Invalid search")}
    end
  end
end
