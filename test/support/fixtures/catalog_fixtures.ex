defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku do
    # Get a unique positive integer (for uniqueness)
    unique = System.unique_integer([:positive])
    # Use modulo to keep it within 900,000 values and add 100,000 to ensure 6 digits
    100_000 + rem(unique, 900_000)
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        unit_price: 20.5
      })
      |> Pento.Catalog.create_product()

    product
  end
end
