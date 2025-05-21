defmodule PentoWeb.RatingLive.Show do
  use Phoenix.Component

  alias PentoWeb.CoreComponents

  attr :rating, :map, required: true

  def stars(assigns) do
    ~H"""
    <div class="flex items-center">
      <%= for _ <- 1..@rating.stars do %>
        <CoreComponents.icon name="hero-star-solid" class="h-5 w-5 text-yellow-400" />
      <% end %>
      <%= for _ <- 1..(5 - @rating.stars) do %>
        <CoreComponents.icon name="hero-star-outline" class="h-5 w-5 text-gray-300" />
      <% end %>
    </div>
    """
  end
end
