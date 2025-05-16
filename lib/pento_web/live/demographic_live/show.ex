defmodule PentoWeb.DemographicLive.Show do
  use Phoenix.Component

  import Phoenix.HTML

  alias Pento.Survey.Demographic
  alias PentoWeb.CoreComponents

  attr :demographic, Demographic, required: true
  attr :class, :string, default: ""

  def details(assigns) do
    ~H"""
    <div class={"font-medium text-2xl #{@class}"}>
      <h2>Demographics {raw("&#x2713;")}</h2>

      <CoreComponents.table
        id="demographic-table"
        rows={[@demographic]}
        first_col_class="font-normal text-blue-500"
      >
        <:col :let={demographic} label="Gender">{demographic.gender}</:col>
        <:col :let={demographic} label="Year of birth">{demographic.year_of_birth}</:col>
      </CoreComponents.table>
    </div>
    """
  end

  attr :message, :string, default: ""
  slot :inner_block, required: true

  def title(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold">{render_slot(@inner_block)}</h1>
    <p>{@message}</p>
    """
  end

  attr :items, :list, default: []
  attr :class, :string, default: ""

  def custom_list(assigns) do
    ~H"""
    <ul class={"list-disc list-inside #{@class}"}>
      <%= for item <- @items do %>
        <li class="text-gray-700">{item}</li>
      <% end %>
    </ul>
    """
  end
end
