defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps(type: :utc_datetime)
  end

  defp validate_unit_price(changeset) do
    validate_number(changeset, :unit_price, greater_than: 0)
  end

  defp validate_lower_price(changeset, old_price) do
    validate_number(changeset, :unit_price, less_than: old_price)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_unit_price()
    |> unique_constraint(:sku)
  end

  @doc false
  def change_unit_price(product, unit_price) do
    product
    |> cast(%{unit_price: unit_price}, [:unit_price])
    |> validate_required([:unit_price])
    |> validate_unit_price()
    |> validate_lower_price(product.unit_price)
  end
end
