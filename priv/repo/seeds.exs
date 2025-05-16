alias Pento.Catalog

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pento.Repo.insert!(%Pento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

products = [
  %{
    name: "Uno",
    description: "UNO is a fun card game",
    unit_price: 10.0,
    sku: 123_456
  },
  %{
    name: "Monopoly",
    description: "Monopoly is a board game",
    unit_price: 20.0,
    sku: 987_654
  },
  %{
    name: "Chess",
    description: "Chess is a board game",
    unit_price: 30.0,
    sku: 176_542
  }
]

Enum.each(products, fn product -> Catalog.create_product(product) end)
