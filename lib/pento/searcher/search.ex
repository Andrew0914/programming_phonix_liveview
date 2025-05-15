defmodule Pento.Searcher.Search do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :sku, :integer
  end

  def changeset(search, attrs) do
    search
    |> cast(attrs, [:sku])
    |> validate_required([:sku])
    |> validate_sku()
  end

  defp validate_sku(changeset) do
    # validate exactly 6 digits in integer (100,000 to 999,999)
    validate_number(changeset, :sku,
      greater_than_or_equal_to: 100_000,
      less_than: 1_000_000,
      message: "SKU is a 6-digit number"
    )
  end
end
