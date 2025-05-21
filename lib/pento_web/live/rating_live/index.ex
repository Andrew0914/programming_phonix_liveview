defmodule PentoWeb.RatingLive.Index do
  use Phoenix.Component

  alias PentoWeb.RatingLive

  attr :products, :list, required: true
  attr :current_user, :any, required: true
  attr :show_ratings, :boolean, default: false

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} />
    <div class="grid grid-cols-2 gap-4 divide-y" id="rating_list">
      <.product_rating
        :for={{p, i} <- Enum.with_index(@products)}
        current_user={@current_user}
        product={p}
        index={i}
      />
    </div>
    """
  end

  attr :products, :list, required: true

  def heading(assigns) do
    ~H"""
    <h2 class="font-medium text-2xl">
      Ratings {if ratings_complete?(@products), do: Phoenix.HTML.raw("&#x2713;")}
    </h2>
    """
  end

  def product_rating(assigns) do
    ~H"""
    <div>
      {@product.name}
    </div>
    <%= if rating = List.first(@product.ratings) do %>
      <RatingLive.Show.stars rating={rating} />
    <% else %>
      <div>
        <.live_component
          module={RatingLive.Form}
          id={@product.id}
          current_user={@current_user}
          product={@product}
          product_index={@index}
        />
      </div>
    <% end %>
    """
  end

  defp ratings_complete?(products) do
    products |> Enum.all?(fn product -> !Enum.empty?(product.ratings) end)
  end
end
