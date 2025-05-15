defmodule Pento.Searcher do
  alias Pento.Searcher.Search
  alias Pento.Catalog

  def change_search(%Search{} = search, attrs \\ %{}) do
    Search.changeset(search, attrs)
  end

  def search_products_by_sku(sku) do
    Catalog.products_by_sku(sku)
  end
end
